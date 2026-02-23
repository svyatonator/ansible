# Операционная документация OpenClaw
## Актуально: LXC workflow (Ubuntu 22)
- Базовая раскатка OpenClaw в LXC (без foundry):
```bash
ansible-playbook -i inventory.ini setup-openclaw-lxc.yml --ask-vault-pass
```
- Отдельная установка foundry plugin:
```bash
ansible-playbook -i inventory.ini setup-openclaw-lxc-foundry-plugin.yml --ask-vault-pass
```
- Включить выдачу `sudo` для пользователя `openclaw` внутри LXC (по умолчанию выключено):
```bash
ansible-playbook -i inventory.ini setup-openclaw-lxc.yml --ask-vault-pass -e '{"openclaw_grant_sudo": true}'
```

### Важные пути (LXC)
- Корень OpenClaw: `/srv/openclaw`
- Runtime-конфиг OpenClaw (LXC): `/srv/openclaw/home/.openclaw/openclaw.json`
- Extensions/plugins (LXC): `/srv/openclaw/home/.openclaw/extensions`
- Unit сервиса в LXC: `/etc/systemd/system/openclaw.service`
- Fixed backup script на хосте: `/usr/local/bin/openclaw-lxc-fixed-backup.sh`
- Fixed restore script на хосте: `/usr/local/bin/openclaw-lxc-fixed-restore.sh`

### Быстрые post-check команды (LXC)
```bash
lxc exec openclaw -- systemctl is-active openclaw.service
lxc exec openclaw -- systemctl status openclaw.service --no-pager -n 50
lxc exec openclaw -- systemctl is-active openclaw-backup.timer
lxc exec openclaw -- bash -lc "test -f /srv/openclaw/home/.openclaw/extensions/foundry-openclaw/index.ts && echo FOUNDRY_OK || echo FOUNDRY_MISSING"
lxc exec openclaw -- journalctl -u openclaw.service -n 200 --no-pager | grep -E '\[foundry\]|Plugin registered|Autonomous overseer' -n
```

### Telegram allowlist
- Список разрешенных Telegram user id задается в `group_vars/openclaw_vault.yml` (`openclaw_telegram_allow_from`).
- Шаблон конфига заполняет allowlist автоматически.
- В базовом LXC-плейбуке `plugins.allow` по умолчанию содержит только `telegram`.
- `foundry-openclaw` добавляется отдельным плейбуком `setup-openclaw-lxc-foundry-plugin.yml` после успешной установки плагина.

### Важно по запуску плейбуков
- `setup-openclaw-lxc.yml` не поддерживает `--check` (dry-run) из-за `lxc launch/start/exec` команд.
- Используйте обычный запуск без `--check`.

### Частая проблема на хостах с Docker
- Симптом: в LXC есть DNS, но `curl -4I https://deb.nodesource.com` из контейнера дает timeout.
- Причина: Docker выставляет `FORWARD DROP`, и трафик `lxdbr0` режется.
- Временный фикс на хосте:
```bash
iptables -I DOCKER-USER 1 -i lxdbr0 -j ACCEPT
iptables -I DOCKER-USER 1 -o lxdbr0 -j ACCEPT
```
- После этого повторите запуск `setup-openclaw-lxc.yml`.

### Fixed backup/restore (LXC)
- Деплой fixed backup+restore скриптов и cron:
```bash
ansible-playbook -i inventory.ini setup-openclaw-lxc-fixed-backup.yml -l <host>
```
- Принудительный запуск бэкапа:
```bash
sudo /usr/local/bin/openclaw-lxc-fixed-backup.sh --run-only
```
- Восстановление из daily:
```bash
sudo /usr/local/bin/openclaw-lxc-fixed-restore.sh
```
- Восстановление из initial:
```bash
sudo /usr/local/bin/openclaw-lxc-fixed-restore.sh --archive /srv/openclaw/backup-fixed/openclaw-initial.tar.gz
```
- Восстановление без pre-restore snapshot:
```bash
sudo /usr/local/bin/openclaw-lxc-fixed-restore.sh --no-pre-backup
```

## Пути на хосте
- Корневой каталог: `/srv/openclaw`
- Файл Compose: `/srv/openclaw/docker-compose.yml`
- Данные и конфиг OpenClaw: `/srv/openclaw/home`
- Активный конфиг (Docker): `/srv/openclaw/home/openclaw.json`
- Активный конфиг (LXC): `/srv/openclaw/home/.openclaw/openclaw.json`
- Skills: `/srv/openclaw/skills`
- Workspace: `/srv/openclaw/workspace`
- Бэкапы: `/srv/openclaw/backup`

## Система бэкапов
- Скрипт ручного бэкапа: `/usr/local/bin/backup-openclaw.sh`
- Скрипт восстановления: `/usr/local/bin/restore-openclaw.sh`
- Systemd service: `openclaw-backup.service`
- Systemd timer: `openclaw-backup.timer`
- Расписание по умолчанию: каждые 3 дня
- Ротация по умолчанию: хранить 3 последних архива

## Операции бэкапа
- Что включается в архив:
- `docker-compose.yml`
- `/srv/openclaw/home`
- `/srv/openclaw/skills`
- `/srv/openclaw/workspace` (если включено в переменных Ansible, поумолчанию - нет, там временные файлы)

- Запуск ручного бэкапа:
```bash
sudo /usr/local/bin/backup-openclaw.sh
```

- Проверка таймера:
```bash
systemctl status openclaw-backup.timer
systemctl list-timers | grep openclaw
```

- Список архивов бэкапов:
```bash
ls -lh /srv/openclaw/backup
```

- Проверить, что архивов не больше 3:
```bash
ls -1 /srv/openclaw/backup/openclaw_*.tar.gz 2>/dev/null | wc -l
```

## Операции восстановления
- Восстановление из архива:
```bash
sudo /usr/local/bin/restore-openclaw.sh /srv/openclaw/backup/openclaw_YYYY-MM-DD_HH-MM-SS.tar.gz
```

- Что делает восстановление:
1. Создает pre-restore snapshot в `/srv/openclaw/backup/pre_restore_*.tar.gz`.
2. Если есть текущий `docker-compose.yml`, останавливает контейнер OpenClaw.
3. Распаковывает архив в `/srv/openclaw` (включая `docker-compose.yml`).
4. Запускает контейнер OpenClaw обратно.

- Восстановление без Ansible:
достаточно иметь Docker и архив бэкапа; `docker-compose.yml` будет восстановлен из архива.

- Проверка после восстановления:
```bash
cd /srv/openclaw
docker compose ps
docker compose logs --tail=200
```

## SSH-туннель для Gateway HTTP/WS
Gateway привязан к localhost на сервере (`127.0.0.1:18789`).

- Открыть туннель с локальной машины:
```bash
ssh -L 18789:127.0.0.1:18789 <user>@<server>
```

- Открыть в локальном браузере:
```text
http://127.0.0.1:18789
```

- URL Canvas при необходимости:
```text
http://127.0.0.1:18789/__openclaw__/canvas/
```

## Деплой и переконфигурация
Запускать после изменений конфигурации:
```bash
ansible-playbook -i inventory.ini setup-openclaw-docker.yml --ask-vault-pass
```

Для LXC-режима (OpenClaw ставится внутри LXC контейнера, без Docker):
```bash
ansible-playbook -i inventory.ini setup-openclaw-lxc.yml --ask-vault-pass
```

## Ручная работа со skills (через SSH)
- Каталог skills на сервере: `/srv/openclaw/skills`
- Добавление/обновление skills вручную:
```bash
cd /srv/openclaw/skills
# добавить или обновить файлы skills
```

- Если skills в git-репозитории:
```bash
cd /srv/openclaw/skills
git pull
```

- Проверка прав доступа для контейнера:
```bash
chown -R 1000:1000 /srv/openclaw/skills
chmod -R u+rwX,go-rwx /srv/openclaw/skills
```

- Применить изменения skills:
```bash
cd /srv/openclaw
docker compose restart
docker compose logs --tail=200
```

## Обновление версии OpenClaw (вручную)
- Перед обновлением сделать бэкап:
```bash
sudo /usr/local/bin/backup-openclaw.sh
```

- Обновить контейнер:
```bash
cd /srv/openclaw
docker compose pull
docker compose up -d
```

- Проверить статус после обновления:
```bash
docker compose ps
docker compose logs --tail=200
```

- При проблеме откатиться из бэкапа:
```bash
sudo /usr/local/bin/restore-openclaw.sh /srv/openclaw/backup/openclaw_YYYY-MM-DD_HH-MM-SS.tar.gz
```

## Управление контейнером OpenClaw
- Остановить контейнер:
```bash
cd /srv/openclaw
docker compose stop
```

- Запустить контейнер обратно:
```bash
cd /srv/openclaw
docker compose start
```

- Полный перезапуск контейнера:
```bash
cd /srv/openclaw
docker compose restart
```

- Проверка состояния:
```bash
cd /srv/openclaw
docker compose ps
```
