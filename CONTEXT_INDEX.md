# Индекс контекста (Ansible репозиторий)

## Обзор репозитория
- Назначение: первичная настройка хостов, управление пользователями, усиление SSH и установка сервисов (Cockpit, fail2ban, auditd, nginx).
- Инвентарь: `inventory.ini`
- Основная конфигурация: `ansible.cfg`
- Альтернативная конфигурация: `ansible_backup_new.cfg`
- Групповые переменные: `group_vars/all.yml`, `group_vars/servers.yml`, `group_vars/bootstrap.yml`
- Плейбуки: `*.yml` в корне репозитория (включая `setup-openclaw-docker.yml`, `setup-openclaw-lxc.yml`, `setup-openclaw-lxc-foundry-plugin.yml`, `setup-openclaw-lxc-fixed-backup.yml`)
- Заметки: `readme`, `rif_log`

## Конфигурация Ansible
- `ansible.cfg`: инвентарь `./inventory.ini`, `host_key_checking = False`, `stdout_callback = yaml`, `interpreter_python = auto_silent`, `timeout = 30`, `become = false` по умолчанию.
- `ansible_backup_new.cfg`: то же, что `ansible.cfg`, плюс `allow_world_readable_tmpfiles = True`.

## Инвентарь
- `inventory.ini`: группы `servers`, `bootstrap`, `openclaw`.
- В `servers`: `u22-test-lxc`, `rif-u22-ger` (один хост закомментирован).

## Переменные
- `new_user`: пользователь для создания в bootstrap‑плейбуках. `group_vars/all.yml`
- `new_user_pubkey`: SSH‑ключ для `new_user`. `group_vars/all.yml`
- `additional_user`: дополнительный sudo‑пользователь после bootstrap. `group_vars/all.yml` (пример закомментирован)
- `additional_user_pubkey`: SSH‑ключ для `additional_user`. `group_vars/all.yml` (пример закомментирован)
- `openclaw_bind_localhost`: если `true`, gateway слушает только localhost в docker-варианте. `group_vars/openclaw.yml`
- `openclaw_gateway_token`: токен доступа к gateway. `group_vars/openclaw_vault.yml` (ansible‑vault)
- `openclaw_telegram_bot_token`: токен Telegram бота. `group_vars/openclaw_vault.yml` (ansible‑vault)
- `openclaw_telegram_allow_from`: список разрешенных Telegram user id (`["*"]` для открытого доступа). `group_vars/openclaw_vault.yml` (ansible‑vault)
- `opencode_api_key`: ключ OpenCode. `group_vars/openclaw_vault.yml` (ansible‑vault)
- `brave_api_key`: ключ Brave API. `group_vars/openclaw_vault.yml` (ansible‑vault)
- `openclaw_primary_model`: основная модель, например `opencode/big-pickle`. `setup-openclaw-docker.yml`
- `openclaw_backup_keep_count`: сколько последних архивов хранить (ротация). `setup-openclaw-docker.yml`
- `openclaw_backup_interval_days`: период запуска systemd timer в днях. `setup-openclaw-docker.yml`
- `openclaw_grant_sudo`: выдача `sudo` прав пользователю `openclaw` внутри LXC (по умолчанию `false`). `setup-openclaw-lxc.yml`
- `openclaw_plugins_allow`: allowlist plugin id для `plugins.allow` в OpenClaw config. `setup-openclaw-lxc.yml`
- `openclaw_lxc_launch_timeout_sec`: timeout на `lxc launch` (сек). `setup-openclaw-lxc.yml`
- `openclaw_cloud_init_timeout_sec`: timeout ожидания cloud-init в LXC (сек). `setup-openclaw-lxc.yml`
- `openclaw_network_wait_retries`: retries сетевых precheck шагов в LXC. `setup-openclaw-lxc.yml`
- `openclaw_network_wait_delay_sec`: delay между retries сетевых precheck шагов в LXC. `setup-openclaw-lxc.yml`
- `openclaw_apt_timeout_sec`: timeout для apt install/update внутри LXC (сек). `setup-openclaw-lxc.yml`
- `openclaw_foundry_package`: npm package foundry plugin. `setup-openclaw-lxc-foundry-plugin.yml`
- `openclaw_lxc_name`: имя LXC-контейнера OpenClaw. `setup-openclaw-lxc.yml`, `setup-openclaw-lxc-foundry-plugin.yml`
- `cockpit_admin_password`: упоминается в комментариях; задается через prompt или vault. `group_vars/all.yml`
- `ansible_user`: `slava` для `servers`. `group_vars/servers.yml`
- `ansible_ssh_private_key_file`: `~/.ssh/operator_key` для `servers`. `group_vars/servers.yml`
- `ansible_become`: `true` для `servers`. `group_vars/servers.yml`
- `ansible_become_method`: `sudo` для `servers`. `group_vars/servers.yml`
- `ansible_user`: `root` для `bootstrap`. `group_vars/bootstrap.yml`
- `ansible_become`: `false` для `bootstrap`. `group_vars/bootstrap.yml`
- `ansible_ssh_private_key_file`: `/home/sshpirko/.ssh/operator_key` для `bootstrap`. `group_vars/bootstrap.yml`

## Плейбуки
- `bootstrap-1-ssh-password-to-root-add-sudouser.yml`
  - Hosts: `bootstrap`
  - Назначение: создать `new_user`, добавить SSH‑ключ, выдать passwordless sudo, разблокировать учетку.
  - Ключевые переменные: `new_user`, `new_user_pubkey`. 
    Пример
    ansible-playbook -i inventory.ini bootstrap-1-ssh-password-to-root-add-sudouser.yml --limit rif-u22-ger
    ssh -i ~/.ssh/operator_key slava@89.125.60.36
- `bootstrap-1-ssh-key-to-root-add-new-sudouser.yml`
  - Hosts: `bootstrap`
  - Назначение: то же, что выше; сценарий для доступа по root SSH key.
  - Ключевые переменные: `new_user`, `new_user_pubkey`.
- `bootstrap-2-remove-root-access.yml`
  - Hosts: `bootstrap`
  - Назначение: запретить root SSH, отключить парольную и keyboard‑interactive аутентификацию.
  - Ключевые переменные: `new_user`.
- `add-new-sudouser.yml`
  - Hosts: `servers`
  - Назначение: добавить `additional_user` с sudo + SSH‑ключом.
  - Ключевые переменные: `additional_user`, `additional_user_pubkey`.
- `setup-cockpit.yml`
  - Hosts: `servers`
  - Назначение: установить Cockpit с 2FA, создать админа, опционально настроить HTTPS.
  - Prompts: `cockpit_admin_password`, `cockpit_ssl_domain` (опционально).
  - Производные переменные: `cockpit_user` (по умолчанию `admin`), `cockpit_user_password`, `cockpit_domain`.
  - Примечания: создает `/etc/cockpit/cockpit.conf`, PAM‑конфиг, опционально использует Let's Encrypt и deploy‑hook.
- `setup-fail2ban.yml`
  - Hosts: `servers`
  - Назначение: установить и настроить fail2ban; условная jail‑конфигурация для cockpit.
  - Примечания: пишет `/etc/fail2ban/jail.local`, опциональный cockpit‑filter.
- `setup-auditd.yml`
  - Hosts: `servers`
  - Назначение: установить auditd и правила для логирования команд и изменений файлов.
  - Примечания: правила в `/etc/audit/rules.d/commands.rules`.
- `setup-istall-nginx.yml`
  - Hosts: `servers`
  - Назначение: установить nginx + certbot и открыть UFW порты 80/443.
- `setup-openclaw-docker.yml`
  - Hosts: `openclaw`
  - Назначение: установить OpenClaw в Docker, настроить папки состояния и бэкап через systemd timer.
  - Особенности бэкапа: первичный бэкап после деплоя при отсутствии архивов, ротация по количеству архивов.
  - Шаблоны: `templates/docker-compose.yml.j2`, `templates/openclaw.json.j2`, `templates/backup-openclaw.sh.j2`, `templates/restore-openclaw.sh.j2`, `templates/openclaw-backup.service.j2`, `templates/openclaw-backup.timer.j2`.
- `setup-openclaw-lxc.yml`
  - Hosts: `openclaw`
  - Назначение: развернуть LXC-контейнер `openclaw`, установить OpenClaw напрямую в контейнер (без Docker), настроить backup/restore и systemd timer внутри контейнера.
  - Особенности: использует runtime-конфиг `{{ openclaw_home }}/.openclaw/openclaw.json`, включает health-check `openclaw.service`, может опционально выдать `sudo` пользователю `openclaw` (`openclaw_grant_sudo=true`), делает явные LXC network precheck и таймауты на `launch/cloud-init/apt`.
  - Ограничение: не поддерживает `--check` mode.
  - Шаблоны: `templates/openclaw-lxc.service.j2`, `templates/openclaw.json.j2`, `templates/backup-openclaw-lxc.sh.j2`, `templates/restore-openclaw-lxc.sh.j2`, `templates/openclaw-backup.service.j2`, `templates/openclaw-backup.timer.j2`.
- `setup-openclaw-lxc-foundry-plugin.yml`
  - Hosts: `openclaw`
  - Назначение: отдельная установка/переустановка `@getfoundry/foundry-openclaw` в уже развернутый LXC OpenClaw.
  - Особенности: идемпотентная проверка по каталогу `.../.openclaw/extensions/foundry-openclaw`, временно убирает `foundry-openclaw` из `plugins.allow` на этапе install (чтобы избежать config-lock), рестарт `openclaw.service`, проверка `active` после установки.
- `setup-openclaw-lxc-fixed-backup.yml`
  - Hosts: `openclaw`
  - Назначение: развернуть fixed backup схему для LXC OpenClaw (один постоянный `initial` + один перезаписываемый `daily`).
  - Особенности: кладет скрипты `/usr/local/bin/openclaw-lxc-fixed-backup.sh` и `/usr/local/bin/openclaw-lxc-fixed-restore.sh`, ставит cron в `/etc/cron.d/openclaw-lxc-fixed-backup` на `04:00`, выполняет один стартовый прогон сразу.
- `cleanup-openclaw-docker-backup.yml`
  - Hosts: `openclaw`
  - Назначение: удалить OpenClaw stack, таймеры/скрипты бэкапа и каталог `/srv/openclaw` (включая бэкапы).
  - Опция: `openclaw_cleanup_remove_docker_engine=true` удаляет Docker Engine и данные `/var/lib/docker`, `/var/lib/containerd`.
- `setup-all settings-volna-ovh.yml`
  - Hosts: `servers`
  - Назначение: настроить статические сайты nginx для `volna.ovh` и поддоменов.
  - Переменные: список `sites` с `domain` и `cert_path`.
- `setup-nginx-docker-volna-ovh.yml`
  - Hosts: `servers`
  - Назначение: перенести nginx для `volna.ovh` в Docker, сохранить HTTPS, перевести renew certbot на webroot.
  - Шаблоны: `templates/docker-compose-nginx-volna.yml.j2`, `templates/nginx-docker-nginx.conf.j2`, `templates/nginx-docker-volna-sites.conf.j2`.

## Certbot на rif-u22-ger (текущая схема)
- Сертификат: `volna.ovh` (SAN: `volna.ovh`, `kit.volna.ovh`, `port.volna.ovh`).
- Пути сертификатов на хосте:
  - `/etc/letsencrypt/live/volna.ovh/fullchain.pem`
  - `/etc/letsencrypt/live/volna.ovh/privkey.pem`
- Nginx работает в Docker и читает сертификаты из хоста через read-only mount:
  - `/etc/letsencrypt:/etc/letsencrypt:ro`
- Продление сертификатов выполняется на хосте через systemd timer:
  - `certbot.timer` -> `certbot renew`
- Для текущей схемы renew используется `webroot`, а не nginx plugin:
  - webroot путь: `/var/www/letsencrypt`
  - в nginx есть `location ^~ /.well-known/acme-challenge/`
- После успешного renew выполняется deploy hook:
  - `/etc/letsencrypt/renewal-hooks/deploy/reload-nginx-docker.sh`
  - действие: `docker exec nginx nginx -s reload`
- Важно: сертификаты не нужно копировать в контейнер вручную; используются файлы с хоста.

## Команды запуска (из `readme`)
- Bootstrap по паролю:
  - `ansible-playbook bootstrap-1-ssh-password-to-root-add-sudouser -k`
  - Проверить SSH как `new_user`, затем:
  - `ansible-playbook bootstrap-2-remove-root-access.yml -k`
- Bootstrap по root SSH key:
  - `ansible-playbook bootstrap-1-ssh-key-to-root-add-new-sudouser`
  - Проверить SSH как `new_user`, затем:
  - `ansible-playbook bootstrap-2-remove-root-access.yml -k`
- Добавить дополнительного sudo‑пользователя:
  - `ansible-playbook add-new-sudouser.yml --limit u22-test-lxc,rif-u22-ger`
  - Или с ad‑hoc переменными:
    `ansible-playbook add-new-sudouser.yml -e "additional_user=ivan" -e "additional_user_pubkey='ssh-ed25519 AAAA... ivan@host'" --limit u22-test-lxc,rif-u22-ger`
- Запрос логов auditd:
  - `ausearch -k commands -ua slava`

## Операционные заметки
- `readme`: описывает bootstrap‑процесс, ручную проверку SSH и добавление пользователей.
- `rif_log`: docker‑команды для контейнера `awg-jump` (неструктурированные заметки).
- `OPENCLAW_OPERATIONS.md`: операции для OpenClaw (пути, backup/restore, SSH‑туннель).
- Актуальный порядок для LXC:
  - сначала `setup-openclaw-lxc.yml`,
  - затем (опционально) `setup-openclaw-lxc-foundry-plugin.yml`.
- На хостах с Docker возможна блокировка LXC egress из-за `FORWARD DROP`; в таком случае нужны правила в `DOCKER-USER` для `lxdbr0`.

## Чувствительные данные
- Публичные SSH‑ключи хранятся в `group_vars/all.yml`.
- Приватные ключи указаны в `group_vars/servers.yml` и `group_vars/bootstrap.yml`.
- Пароль админа Cockpit задается через prompt или vault (см. `readme`).
