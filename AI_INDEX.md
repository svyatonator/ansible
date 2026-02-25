# AI Agent Index (Ansible Repository)

> Optimized index for AI agents to quickly locate variables, files, and configurations.

## Quick Variable Reference

### User Management Variables
| Variable | Default | Location | Description |
|----------|---------|----------|-------------|
| `new_user` | `slava` | [`group_vars/all.yml`](group_vars/all.yml:1) | Primary sudo user for bootstrap |
| `new_user_pubkey` | `ssh-ed25519 AAAA...` | [`group_vars/all.yml`](group_vars/all.yml:2) | SSH public key for new_user |
| `additional_user` | *(commented)* | [`group_vars/all.yml`](group_vars/all.yml:4) | Secondary sudo user |
| `additional_user_pubkey` | *(commented)* | [`group_vars/all.yml`](group_vars/all.yml:5) | SSH key for additional_user |
| `ansible_user` | `slava` (servers), `root` (bootstrap) | [`group_vars/servers.yml`](group_vars/servers.yml:1), [`group_vars/bootstrap.yml`](group_vars/bootstrap.yml) | SSH login user |
| `ansible_ssh_private_key_file` | `~/.ssh/operator_key` | [`group_vars/servers.yml`](group_vars/servers.yml:2) | Path to SSH private key |
| `ansible_become` | `true` (servers), `false` (bootstrap) | [`group_vars/servers.yml`](group_vars/servers.yml:3) | Enable privilege escalation |
| `ansible_become_method` | `sudo` | [`group_vars/servers.yml`](group_vars/servers.yml:4) | Become method |

### OpenClaw Core Variables
| Variable | Default | Location | Description |
|----------|---------|----------|-------------|
| `openclaw_root` | `/srv/openclaw` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:7), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:8) | Base directory |
| `openclaw_home` | `{{ openclaw_root }}/home` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:8), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:9) | Home directory |
| `openclaw_skills` | `{{ openclaw_root }}/skills` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:9), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:10) | Skills directory |
| `openclaw_workspace` | `{{ openclaw_root }}/workspace` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:10), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:11) | Workspace directory |
| `openclaw_backup` | `{{ openclaw_root }}/backup` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:11), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:12) | Backup directory |
| `openclaw_uid` | `1000` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:12), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:13) | User ID |
| `openclaw_gid` | `1000` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:13), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:14) | Group ID |
| `openclaw_user` | `1000:1000` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:14), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:15) | User:group string |
| `openclaw_container_home` | `/home/node` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:15), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:16) | Container home path |
| `openclaw_container_data` | `/home/node/.openclaw` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:16), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:17) | Container data path |
| `openclaw_primary_model` | `opencode/big-pickle` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:18), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:19) | Default AI model |
| `openclaw_image` | `ghcr.io/openclaw/openclaw:latest` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:21), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:20) | Docker image |
| `openclaw_port` | `18789` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:22), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:21) | Gateway port |
| `openclaw_command` | `[]` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:33), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:22) | Container command override |

### OpenClaw Backup Variables
| Variable | Default | Location | Description |
|----------|---------|----------|-------------|
| `openclaw_backup_keep_count` | `3` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:36), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:23) | Number of backups to keep |
| `openclaw_backup_interval_days` | `3` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:37), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:24) | Backup timer interval |
| `openclaw_backup_include_workspace` | `false` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:38), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:25) | Include workspace in backup |
| `openclaw_skills_git_init` | `false` | [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml:41), [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:26) | Initialize git in skills |

### OpenClaw LXC-Specific Variables
| Variable | Default | Location | Description |
|----------|---------|----------|-------------|
| `openclaw_lxc_name` | `openclaw` | [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:35) | LXC container name |
| `openclaw_lxc_image` | `ubuntu:22.04` | [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:36) | LXC image |
| `openclaw_lxc_launch_timeout_sec` | `900` | [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:37) | Launch timeout |
| `openclaw_cloud_init_timeout_sec` | `300` | [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:38) | Cloud-init timeout |
| `openclaw_network_wait_retries` | `20` | [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:39) | Network check retries |
| `openclaw_network_wait_delay_sec` | `5` | [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:40) | Delay between retries |
| `openclaw_apt_timeout_sec` | `300` | [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:41) | apt operation timeout |
| `openclaw_grant_sudo` | `false` | [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:42) | Grant sudo to openclaw user |
| `openclaw_plugins_allow` | `['telegram']` | [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml:43) | Allowed plugins list |

### OpenClaw Secrets (Vault)
| Variable | Location | Description |
|----------|----------|-------------|
| `openclaw_gateway_token` | [`group_vars/openclaw_vault.yml`](group_vars/openclaw_vault.yml) (vault) | Gateway access token |
| `openclaw_telegram_bot_token` | [`group_vars/openclaw_vault.yml`](group_vars/openclaw_vault.yml) (vault) | Telegram bot token |
| `openclaw_telegram_allow_from` | [`group_vars/openclaw_vault.yml`](group_vars/openclaw_vault.yml) (vault) | Allowed Telegram user IDs |
| `opencode_api_key` | [`group_vars/openclaw_vault.yml`](group_vars/openclaw_vault.yml) (vault) | OpenCode API key |
| `brave_api_key` | [`group_vars/openclaw_vault.yml`](group_vars/openclaw_vault.yml) (vault) | Brave API key |

### OpenClaw Non-Secret Defaults
| Variable | Default | Location | Description |
|----------|---------|----------|-------------|
| `openclaw_bind_localhost` | `true` | [`group_vars/openclaw.yml`](group_vars/openclaw.yml:2) | Bind gateway to localhost only |

### Cockpit Variables
| Variable | Location | Description |
|----------|----------|-------------|
| `cockpit_admin_password` | [`group_vars/all.yml`](group_vars/all.yml:8) (commented) | Admin password (prompt/vault) |
| `cockpit_user` | `admin` (default in playbook) | [`setup-cockpit.yml`](setup-cockpit.yml) | Cockpit admin username |
| `cockpit_user_password` | derived | [`setup-cockpit.yml`](setup-cockpit.yml) | Generated password |
| `cockpit_domain` | optional prompt | [`setup-cockpit.yml`](setup-cockpit.yml) | Domain for HTTPS |

---

## File Reference Map

### Configuration Files
| File | Purpose |
|------|---------|
| [`ansible.cfg`](ansible.cfg) | Main Ansible config (inventory, callbacks, timeouts) |
| [`ansible_backup_new.cfg`](ansible_backup_new.cfg) | Backup config with `allow_world_readable_tmpfiles` |
| [`inventory.ini`](inventory.ini) | Host inventory (servers, bootstrap, openclaw groups) |

### Group Variables
| File | Group | Purpose |
|------|-------|---------|
| [`group_vars/all.yml`](group_vars/all.yml) | all | Global variables (users, SSH keys) |
| [`group_vars/servers.yml`](group_vars/servers.yml) | servers | Connection settings for servers |
| [`group_vars/bootstrap.yml`](group_vars/bootstrap.yml) | bootstrap | Bootstrap-specific overrides |
| [`group_vars/openclaw.yml`](group_vars/openclaw.yml) | openclaw | Non-secret OpenClaw defaults |
| [`group_vars/openclaw_vault.yml`](group_vars/openclaw_vault.yml) | openclaw | **ENCRYPTED** - OpenClaw secrets |

### Playbooks by Category

#### Bootstrap Playbooks
| File | Hosts | Purpose |
|------|-------|---------|
| [`bootstrap-1-ssh-password-to-root-add-sudouser.yml`](bootstrap-1-ssh-password-to-root-add-sudouser.yml) | bootstrap | Create sudo user via root SSH + password |
| [`bootstrap-1-ssh-key-to-root-add-new-sudouser.yml`](bootstrap-1-ssh-key-to-root-add-new-sudouser.yml) | bootstrap | Create sudo user via root SSH key |
| [`bootstrap-2-remove-root-access.yml`](bootstrap-2-remove-root-access.yml) | bootstrap | Disable root SSH and password auth |

#### User Management
| File | Hosts | Purpose |
|------|-------|---------|
| [`add-new-sudouser.yml`](add-new-sudouser.yml) | servers | Add additional sudo user |

#### Service Setup
| File | Hosts | Purpose |
|------|-------|---------|
| [`setup-cockpit.yml`](setup-cockpit.yml) | servers | Install Cockpit with 2FA |
| [`setup-fail2ban.yml`](setup-fail2ban.yml) | servers | Configure fail2ban |
| [`setup-auditd.yml`](setup-auditd.yml) | servers | Setup audit logging |
| [`setup-istall-nginx.yml`](setup-istall-nginx.yml) | servers | Install nginx + certbot |

#### OpenClaw Deployment
| File | Hosts | Purpose |
|------|-------|---------|
| [`setup-openclaw-docker.yml`](setup-openclaw-docker.yml) | openclaw | Deploy OpenClaw in Docker |
| [`setup-openclaw-lxc.yml`](setup-openclaw-lxc.yml) | openclaw | Deploy OpenClaw in LXC container |
| [`setup-openclaw-lxc-foundry-plugin.yml`](setup-openclaw-lxc-foundry-plugin.yml) | openclaw | Install Foundry plugin in LXC |
| [`setup-openclaw-lxc-fixed-backup.yml`](setup-openclaw-lxc-fixed-backup.yml) | openclaw | Setup fixed backup scheme |
| [`cleanup-openclaw-docker-backup.yml`](cleanup-openclaw-docker-backup.yml) | openclaw | Remove OpenClaw Docker stack |

#### Nginx/Sites
| File | Hosts | Purpose |
|------|-------|---------|
| [`setup-all settings-volna-ovh.yml`](setup-all settings-volna-ovh.yml) | servers | Static sites for volna.ovh |
| [`setup-nginx-docker-volna-ovh.yml`](setup-nginx-docker-volna-ovh.yml) | servers | Nginx in Docker for volna.ovh |

### Templates
| Template | Used By | Output Path |
|----------|---------|-------------|
| [`templates/docker-compose.yml.j2`](templates/docker-compose.yml.j2) | setup-openclaw-docker.yml | `/srv/openclaw/docker-compose.yml` |
| [`templates/openclaw.json.j2`](templates/openclaw.json.j2) | setup-openclaw-*.yml | OpenClaw config file |
| [`templates/backup-openclaw.sh.j2`](templates/backup-openclaw.sh.j2) | setup-openclaw-docker.yml | Backup script |
| [`templates/restore-openclaw.sh.j2`](templates/restore-openclaw.sh.j2) | setup-openclaw-docker.yml | Restore script |
| [`templates/openclaw-backup.service.j2`](templates/openclaw-backup.service.j2) | setup-openclaw-*.yml | Systemd service |
| [`templates/openclaw-backup.timer.j2`](templates/openclaw-backup.timer.j2) | setup-openclaw-docker.yml | Systemd timer |
| [`templates/openclaw-lxc.service.j2`](templates/openclaw-lxc.service.j2) | setup-openclaw-lxc.yml | LXC systemd service |
| [`templates/backup-openclaw-lxc.sh.j2`](templates/backup-openclaw-lxc.sh.j2) | setup-openclaw-lxc.yml | LXC backup script |
| [`templates/restore-openclaw-lxc.sh.j2`](templates/restore-openclaw-lxc.sh.j2) | setup-openclaw-lxc.yml | LXC restore script |
| [`templates/openclaw-lxc-fixed-backup.cron.j2`](templates/openclaw-lxc-fixed-backup.cron.j2) | setup-openclaw-lxc-fixed-backup.yml | Cron file |
| [`templates/docker-compose-nginx-volna.yml.j2`](templates/docker-compose-nginx-volna.yml.j2) | setup-nginx-docker-volna-ovh.yml | Docker compose |
| [`templates/nginx-docker-nginx.conf.j2`](templates/nginx-docker-nginx.conf.j2) | setup-nginx-docker-volna-ovh.yml | Nginx config |
| [`templates/nginx-docker-volna-sites.conf.j2`](templates/nginx-docker-volna-sites.conf.j2) | setup-nginx-docker-volna-ovh.yml | Sites config |
| [`templates/ssh-telegram-notifier.py.j2`](templates/ssh-telegram-notifier.py.j2) | setup-ssh-login-telegram-alert.yml | SSH alert script |
| [`templates/ssh-telegram-notifier.service.j2`](templates/ssh-telegram-notifier.service.j2) | setup-ssh-login-telegram-alert.yml | Systemd service |
| [`templates/ssh-telegram-notifier.env.j2`](templates/ssh-telegram-notifier.env.j2) | setup-ssh-login-telegram-alert.yml | Environment file |

### Scripts
| Script | Purpose |
|--------|---------|
| [`scripts/openclaw-lxc-fixed-backup.sh`](scripts/openclaw-lxc-fixed-backup.sh) | Fixed backup for LXC |
| [`scripts/openclaw-lxc-fixed-restore.sh`](scripts/openclaw-lxc-fixed-restore.sh) | Fixed restore for LXC |

---

## Inventory Groups

```
[servers]       # Production servers with sudo access
├── vova-u22 (81.29.146.124)
└── (commented: rif-u22-ger, u22-test-lxc, priboi-u22-ru)

[bootstrap]     # New hosts for initial setup (root access)
└── (commented: rif-u22-ger)

[openclaw]      # OpenClaw deployment targets
├── vova-u22 (81.29.146.124)
└── (commented: rif-u22-ger)
```

---

## Common Tasks Quick Reference

### Add new sudo user
```bash
ansible-playbook add-new-sudouser.yml \
  -e "additional_user=ivan" \
  -e "additional_user_pubkey='ssh-ed25519 AAAA...'" \
  --limit u22-test-lxc,rif-u22-ger
```

### Bootstrap new server (password)
```bash
ansible-playbook bootstrap-1-ssh-password-to-root-add-sudouser.yml -k
# Test SSH as new_user
ansible-playbook bootstrap-2-remove-root-access.yml -k
```

### Deploy OpenClaw (LXC)
```bash
ansible-playbook setup-openclaw-lxc.yml
# Optionally add Foundry plugin:
ansible-playbook setup-openclaw-lxc-foundry-plugin.yml
```

### Deploy OpenClaw (Docker)
```bash
ansible-playbook setup-openclaw-docker.yml
```

---

## Variable Search Patterns

### Find where variable is defined
```
grep -r "variable_name:" group_vars/ *.yml
```

### Find where variable is used
```
grep -r "{{ variable_name }}" . --include="*.yml" --include="*.j2"
```

### Find vault-encrypted variables
```
grep -r "vault" group_vars/
```

---

## Dependencies Between Files

```
setup-openclaw-docker.yml
├── group_vars/openclaw_vault.yml (secrets)
├── templates/docker-compose.yml.j2
├── templates/openclaw.json.j2
├── templates/backup-openclaw.sh.j2
├── templates/restore-openclaw.sh.j2
├── templates/openclaw-backup.service.j2
└── templates/openclaw-backup.timer.j2

setup-openclaw-lxc.yml
├── group_vars/openclaw_vault.yml (secrets)
├── templates/openclaw-lxc.service.j2
├── templates/openclaw.json.j2
├── templates/backup-openclaw-lxc.sh.j2
├── templates/restore-openclaw-lxc.sh.j2
├── templates/openclaw-backup.service.j2
└── templates/openclaw-backup.timer.j2
```

---

## Notes for AI Agents

1. **Vault files are encrypted**: `group_vars/openclaw_vault.yml` and `group_vars/telegram-bot-alert_vault.yml` require ansible-vault password.

2. **LXC playbook limitation**: `setup-openclaw-lxc.yml` does not support `--check` mode.

3. **OpenClaw deployment order**: 
   - First: `setup-openclaw-lxc.yml`
   - Then (optional): `setup-openclaw-lxc-foundry-plugin.yml`

4. **Docker vs LXC**: Both OpenClaw playbooks share most variables but differ in:
   - `openclaw_config_path`: Docker uses `{{ openclaw_home }}/openclaw.json`, LXC uses `{{ openclaw_home }}/.openclaw/openclaw.json`
   - LXC has additional timeout/retry variables

5. **Sensitive data locations**:
   - SSH public keys: `group_vars/all.yml` (safe)
   - SSH private key paths: `group_vars/servers.yml`, `group_vars/bootstrap.yml`
   - All secrets: `*_vault.yml` files (encrypted)
