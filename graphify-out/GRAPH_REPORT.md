# Graph Report - .  (2026-06-08)

## Corpus Check
- 44 files · ~22,180 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 138 nodes · 121 edges · 34 communities (13 shown, 21 thin omitted)
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 11 edges (avg confidence: 0.92)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Project Indices & Bootstrapping|Project Indices & Bootstrapping]]
- [[_COMMUNITY_Core Ansible Infrastructure|Core Ansible Infrastructure]]
- [[_COMMUNITY_Repository Inventory & Context|Repository Inventory & Context]]
- [[_COMMUNITY_OpenClaw Operational Workflows|OpenClaw Operational Workflows]]
- [[_COMMUNITY_AmneziaWG Configuration Logic|AmneziaWG Configuration Logic]]
- [[_COMMUNITY_OpenClaw Configuration Variables|OpenClaw Configuration Variables]]
- [[_COMMUNITY_Ostrov Machine Management|Ostrov Machine Management]]
- [[_COMMUNITY_AI Agent & Bootstrap Automation|AI Agent & Bootstrap Automation]]
- [[_COMMUNITY_LXC Workflow & Playbook Tips|LXC Workflow & Playbook Tips]]
- [[_COMMUNITY_Security & Database Services (CouchDB, Fail2ban)|Security & Database Services (CouchDB, Fail2ban)]]
- [[_COMMUNITY_OpenClaw BackupRestore Scripts|OpenClaw Backup/Restore Scripts]]
- [[_COMMUNITY_VPN Config & Xray Extraction|VPN Config & Xray Extraction]]
- [[_COMMUNITY_OpenClaw LXC Specific Deployments|OpenClaw LXC Specific Deployments]]
- [[_COMMUNITY_Gemini & Tool Configuration|Gemini & Tool Configuration]]
- [[_COMMUNITY_Ostrov Variables & AWG Importer|Ostrov Variables & AWG Importer]]
- [[_COMMUNITY_Nginx Proxy & Server Vars|Nginx Proxy & Server Vars]]
- [[_COMMUNITY_Telegram Notifications & Vaults|Telegram Notifications & Vaults]]
- [[_COMMUNITY_Static Site Deployments|Static Site Deployments]]
- [[_COMMUNITY_AmneziaWG Client Setup|AmneziaWG Client Setup]]
- [[_COMMUNITY_Mesh VPN & Headscale|Mesh VPN & Headscale]]
- [[_COMMUNITY_AmneziaWG Cleanup|AmneziaWG Cleanup]]
- [[_COMMUNITY_Docker Stack Cleanup|Docker Stack Cleanup]]
- [[_COMMUNITY_OpenClaw Lifecycle|OpenClaw Lifecycle]]
- [[_COMMUNITY_Gemini Graph Rules|Gemini Graph Rules]]
- [[_COMMUNITY_System Auditing (Auditd)|System Auditing (Auditd)]]
- [[_COMMUNITY_DERP Relay Setup|DERP Relay Setup]]
- [[_COMMUNITY_NginxCertbot Installation|Nginx/Certbot Installation]]
- [[_COMMUNITY_MTProto Proxy|MTProto Proxy]]
- [[_COMMUNITY_OpenClaw Docker Deployment|OpenClaw Docker Deployment]]
- [[_COMMUNITY_XrayVLESS Scaffolding|Xray/VLESS Scaffolding]]
- [[_COMMUNITY_Gemini Settings|Gemini Settings]]
- [[_COMMUNITY_OpenClaw Public Config|OpenClaw Public Config]]
- [[_COMMUNITY_OpenClaw Vault Secrets|OpenClaw Vault Secrets]]
- [[_COMMUNITY_Amnezia VPN Parser|Amnezia VPN Parser]]

## God Nodes (most connected - your core abstractions)
1. `Операционная документация OpenClaw` - 11 edges
2. `Индекс контекста (Ansible репозиторий)` - 10 edges
3. `AI Agent Index (Ansible Repository)` - 8 edges
4. `Quick Variable Reference` - 8 edges
5. `Актуально: LXC workflow (Ubuntu 22)` - 7 edges
6. `Ostrov` - 7 edges
7. `build_awg_block()` - 6 edges
8. `File Reference Map` - 6 edges
9. `Playbooks by Category` - 6 edges
10. `fail()` - 5 edges

## Surprising Connections (you probably didn't know these)
- `AI Agent Index` --semantically_similar_to--> `Repository Context Index`  [INFERRED] [semantically similar]
  AI_INDEX.md → CONTEXT_INDEX.md
- `Nginx Docker Static Sites` --semantically_similar_to--> `Nginx Volna.ovh Static Sites Setup`  [INFERRED] [semantically similar]
  setup-nginx-docker-volna-ovh.yml → setup-all settings-volna-ovh.yml
- `AmneziaWG LXC Client Setup` --semantically_similar_to--> `AmneziaWG Host Client Setup`  [INFERRED] [semantically similar]
  setup-awg-client-lxc.yml → setup-awg-client.yml
- `AmneziaWG Config Importer` --references--> `Ostrov Group Variables`  [EXTRACTED]
  scripts/import-awg-config.py → group_vars/ostrov.yml
- `Bootstrap: Root SSH Key to New Sudo User` --conceptually_related_to--> `Bootstrap: Remove Root Access`  [INFERRED]
  bootstrap-1-ssh-key-to-root-add-new-sudouser.yml → bootstrap-2-remove-root-access.yml

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **OpenClaw LXC Fixed Backup Mechanism** — scripts_openclaw_lxc_fixed_backup_script, scripts_openclaw_lxc_fixed_restore_script, ansible_openclaw_operations_document [INFERRED 0.95]
- **Initial Server Bootstrap Workflow** — ansible_bootstrap_1_ssh_key_to_root_add_new_sudouser_playbook, ansible_bootstrap_2_remove_root_access_playbook, group_vars_bootstrap_vars [INFERRED 0.95]
- **OpenClaw Deployment & Maintenance** — ansible_setup_openclaw_docker_playbook, ansible_setup_openclaw_lxc_playbook, ansible_setup_openclaw_lxc_fixed_backup_playbook, ansible_setup_openclaw_lxc_foundry_plugin_playbook [INFERRED 0.95]
- **Secure Tunneling & VPN Infrastructure** — ansible_setup_awg_client_playbook, ansible_setup_tailscale_client_playbook, ansible_setup_xray_client_docker_playbook, ansible_setup_mtproto_docker_playbook, ansible_setup_derper_playbook, ansible_setup_headscale_derp_docker_playbook [INFERRED 0.85]
- **Ostrov Connectivity Topology** — ansible_ostrov_doc, ansible_setup_lxc_ostrov_playbook, ansible_concept_reverse_ssh_tunnel [INFERRED 0.95]

## Communities (34 total, 21 thin omitted)

### Community 0 - "Project Indices & Bootstrapping"
Cohesion: 0.14
Nodes (13): Add new sudo user, AI Agent Index (Ansible Repository), Bootstrap new server (password), Common Tasks Quick Reference, Dependencies Between Files, Deploy OpenClaw (Docker), Deploy OpenClaw (LXC), Find vault-encrypted variables (+5 more)

### Community 1 - "Core Ansible Infrastructure"
Cohesion: 0.18
Nodes (11): Bootstrap Playbooks, Configuration Files, File Reference Map, Group Variables, Nginx/Sites, OpenClaw Deployment, Playbooks by Category, Scripts (+3 more)

### Community 2 - "Repository Inventory & Context"
Cohesion: 0.18
Nodes (10): Certbot на rif-u22-ger (текущая схема), Инвентарь, Индекс контекста (Ansible репозиторий), Команды запуска (из `readme`), Конфигурация Ansible, Обзор репозитория, Операционные заметки, Переменные (+2 more)

### Community 3 - "OpenClaw Operational Workflows"
Cohesion: 0.18
Nodes (10): SSH-туннель для Gateway HTTP/WS, Деплой и переконфигурация, Обновление версии OpenClaw (вручную), Операции бэкапа, Операции восстановления, Операционная документация OpenClaw, Пути на хосте, Ручная работа со skills (через SSH) (+2 more)

### Community 4 - "AmneziaWG Configuration Logic"
Cohesion: 0.33
Nodes (9): Namespace, build_awg_block(), main(), parse_args(), replace_awg_block(), split_csv(), yaml_list(), yaml_quote() (+1 more)

### Community 5 - "OpenClaw Configuration Variables"
Cohesion: 0.25
Nodes (8): Cockpit Variables, OpenClaw Backup Variables, OpenClaw Core Variables, OpenClaw LXC-Specific Variables, OpenClaw Non-Secret Defaults, OpenClaw Secrets (Vault), Quick Variable Reference, User Management Variables

### Community 6 - "Ostrov Machine Management"
Cohesion: 0.25
Nodes (7): Ostrov, Systemd unit на ostrov, Важные детали, Как подключаться вручную, Как работает Ansible, Схема доступа, Что нельзя забывать

### Community 7 - "AI Agent & Bootstrap Automation"
Cohesion: 0.29
Nodes (7): Add New Sudo User Playbook, AI Agent Index, Bootstrap: Root SSH Key to New Sudo User, Bootstrap: Remove Root Access, Repository Context Index, Global Variables (All Groups), Bootstrap Group Variables

### Community 8 - "LXC Workflow & Playbook Tips"
Cohesion: 0.29
Nodes (7): Fixed backup/restore (LXC), Telegram allowlist, Актуально: LXC workflow (Ubuntu 22), Быстрые post-check команды (LXC), Важно по запуску плейбуков, Важные пути (LXC), Частая проблема на хостах с Docker

### Community 9 - "Security & Database Services (CouchDB, Fail2ban)"
Cohesion: 0.33
Nodes (6): Reverse SSH Tunneling Mechanism, Ostrov Machine Documentation, Cockpit Web Console with 2FA, CouchDB for Obsidian LiveSync, Fail2ban Security Hardening, Ostrov LXC Provisioning with Reverse SSH

### Community 11 - "VPN Config & Xray Extraction"
Cohesion: 0.80
Nodes (5): build_summary(), decode_export(), extract_xray_config(), fail(), main()

### Community 12 - "OpenClaw LXC Specific Deployments"
Cohesion: 0.67
Nodes (3): OpenClaw LXC Fixed Backup Policy, OpenClaw Foundry Plugin Install, OpenClaw AI LXC Deployment

### Community 14 - "Ostrov Variables & AWG Importer"
Cohesion: 0.67
Nodes (3): Ostrov LXC Group Variables, Ostrov Group Variables, AmneziaWG Config Importer

## Knowledge Gaps
- **92 isolated node(s):** `Namespace`, `SectionProxy`, `User Management Variables`, `OpenClaw Core Variables`, `OpenClaw Backup Variables` (+87 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **21 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AI Agent Index (Ansible Repository)` connect `Project Indices & Bootstrapping` to `Core Ansible Infrastructure`, `OpenClaw Configuration Variables`?**
  _High betweenness centrality (0.043) - this node is a cross-community bridge._
- **Why does `File Reference Map` connect `Core Ansible Infrastructure` to `Project Indices & Bootstrapping`?**
  _High betweenness centrality (0.027) - this node is a cross-community bridge._
- **Why does `Quick Variable Reference` connect `OpenClaw Configuration Variables` to `Project Indices & Bootstrapping`?**
  _High betweenness centrality (0.021) - this node is a cross-community bridge._
- **What connects `Namespace`, `SectionProxy`, `User Management Variables` to the rest of the system?**
  _92 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Project Indices & Bootstrapping` be split into smaller, more focused modules?**
  _Cohesion score 0.14285714285714285 - nodes in this community are weakly interconnected._