# Ostrov

`ostrov` — это домашний ПК Slava на Ubuntu 24 LTS. Машина находится за несколькими NAT и не имеет прямого входящего SSH-доступа из интернета.

## Схема доступа

Прямое подключение с ноутбука к `ostrov` невозможно.

Доступ делается через сервер `priboi` (`212.15.49.66`) с помощью reverse SSH tunnel:

`ostrov -> priboi:localhost:3333 -> ostrov:22`

То есть:

- `ostrov` сам инициирует исходящее SSH-подключение к `priboi`
- на `priboi` поднимается порт `localhost:3333`
- все подключения к `priboi:localhost:3333` попадают в `sshd` на `ostrov`

## Systemd unit на ostrov

Файл: `/etc/systemd/system/reverse-ssh.service`

```ini
[Unit]
Description=Reverse SSH Tunnel to priboi
After=network-online.target
Wants=network-online.target

[Service]
User=slava
ExecStart=/usr/bin/autossh -M 0 -N -i /home/slava/.ssh/id_ed25519_priboi -o "StrictHostKeyChecking=yes" -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o "ExitOnForwardFailure yes" -R 3333:localhost:22 slava@212.15.49.66
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

## Важные детали

- tunnel создается с `ostrov` на `priboi`, а не наоборот
- порт `3333` на `priboi` обычно слушает только на loopback, то есть использовать нужно именно `localhost:3333` на самом `priboi`
- если сломать или отключить `reverse-ssh.service`, удаленный доступ к `ostrov` пропадает
- менять этот unit нужно очень осторожно: ошибка в ключе, пользователе, порте или `autossh` может полностью отрезать машину

## Как подключаться вручную

С ноутбука сначала нужен доступ к `priboi` по SSH-ключу `operator_key`.

Ключ `operator_key` защищен passphrase, поэтому перед работой обычно нужно:

```bash
eval "$(ssh-agent -s)"
ssh-add /home/slava/.ssh/operator_key
```

После этого SSH-маршрут до `ostrov` идет через `priboi`.

На `ostrov` пользователь для входа: `slava`.

- SSH-пароль пользователя `slava` на `ostrov` известен локально на ноутбуке
- `sudo` пароль у `slava` совпадает с SSH-паролем
- пароли и ключи `ostrov` не должны храниться на `priboi`

## Как работает Ansible

Ansible запускается с ноутбука, а не на `priboi`.

Схема такая:

1. Ansible подключается к `priboi` по `operator_key`
2. через `ProxyCommand`/jump host идет на `127.0.0.1:3333` на `priboi`
3. это соединение попадает в `sshd` на `ostrov`
4. на `ostrov` вход идет как `slava` по паролю

В репозитории для этого добавлены:

- группа `ostrov` в `inventory.ini`
- host `ostrov-u24` с `ansible_host=127.0.0.1` и `ansible_port=3333`
- `group_vars/ostrov.yml` с SSH-маршрутом через `priboi`

Типовой запуск:

```bash
ansible ostrov -m ping -k -K
ansible-playbook setup-ssh-login-telegram-alert.yml -e target_hosts=ostrov --ask-vault-pass -k -K
```

Где:

- `-k` спрашивает SSH-пароль пользователя `slava` на `ostrov`
- `-K` спрашивает `sudo` пароль на `ostrov`
- passphrase от `operator_key` вводится отдельно через `ssh-agent` / `ssh-add`

## Что нельзя забывать

- если `priboi` недоступен, то `ostrov` тоже недоступен
- если на `ostrov` не работает `reverse-ssh.service`, то Ansible и обычный SSH перестают проходить
- ошибки вида `Permission denied` до `212.15.49.66` обычно относятся к первому хопу (`priboi`)
- ошибки на `127.0.0.1:3333` обычно относятся уже к tunnel или к самому `ostrov`
- не надо "чинить" tunnel агрессивно, если нет точного понимания: это легко ломает единственный путь доступа
