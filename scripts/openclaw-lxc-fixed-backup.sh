#!/usr/bin/env bash
set -Eeuo pipefail

LXC_NAME="${LXC_NAME:-openclaw}"
CONTAINER_DATA_ROOT="${CONTAINER_DATA_ROOT:-/srv/openclaw}"
HOST_BACKUP_DIR="${HOST_BACKUP_DIR:-/srv/openclaw/backup-fixed}"
INITIAL_NAME="${INITIAL_NAME:-openclaw-initial.tar.gz}"
DAILY_NAME="${DAILY_NAME:-openclaw-daily.tar.gz}"
CRON_FILE="${CRON_FILE:-/etc/cron.d/openclaw-fixed-backup}"
LOCK_FILE="${LOCK_FILE:-/var/lock/openclaw-fixed-backup.lock}"

SCRIPT_PATH="$(readlink -f "$0")"
INSTALL_CRON=true
RUN_BACKUP=true

usage() {
  cat <<'EOF'
Usage:
  openclaw-lxc-fixed-backup.sh [--run-only] [--install-only] [--no-cron]

Behavior:
  - Creates one permanent initial backup (if missing): openclaw-initial.tar.gz
  - Creates/overwrites one daily backup: openclaw-daily.tar.gz
  - Installs cron at 04:00 by default.

Environment overrides:
  LXC_NAME, CONTAINER_DATA_ROOT, HOST_BACKUP_DIR,
  INITIAL_NAME, DAILY_NAME, CRON_FILE, LOCK_FILE
EOF
}

for arg in "$@"; do
  case "$arg" in
    --run-only) INSTALL_CRON=false ;;
    --install-only) RUN_BACKUP=false ;;
    --no-cron) INSTALL_CRON=false ;;
    -h|--help) usage; exit 0 ;;
    *)
      echo "Unknown option: $arg" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root." >&2
  exit 1
fi

for cmd in lxc tar flock bash; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing required command: $cmd" >&2
    exit 1
  fi
done

mkdir -p "$HOST_BACKUP_DIR" "$(dirname "$LOCK_FILE")"

if [[ "$INSTALL_CRON" == true ]]; then
  cat >"$CRON_FILE" <<EOF
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
0 4 * * * root ${SCRIPT_PATH} --run-only >/var/log/openclaw-fixed-backup.log 2>&1
EOF
  chmod 0644 "$CRON_FILE"
fi

if [[ "$RUN_BACKUP" != true ]]; then
  echo "Cron installed at 04:00 in $CRON_FILE"
  exit 0
fi

exec 9>"$LOCK_FILE"
if ! flock -n 9; then
  echo "Another backup run is in progress." >&2
  exit 1
fi

if ! lxc info "$LXC_NAME" >/dev/null 2>&1; then
  echo "Container '$LXC_NAME' not found." >&2
  exit 1
fi

if ! lxc list "$LXC_NAME" --format csv -c s | grep -q "^RUNNING$"; then
  lxc start "$LXC_NAME" >/dev/null
fi

create_archive() {
  local target="$1"
  local tmp="${target}.tmp"

  lxc exec "$LXC_NAME" -- bash -lc "
    set -e
    files=(\"${CONTAINER_DATA_ROOT#/}\")
    for f in \
      etc/systemd/system/openclaw.service \
      etc/systemd/system/openclaw-backup.service \
      etc/systemd/system/openclaw-backup.timer; do
      [[ -e \"/\$f\" ]] && files+=(\"\$f\")
    done
    tar -C / -czf - \"\${files[@]}\"
  " >"$tmp"

  mv -f "$tmp" "$target"
}

initial_path="${HOST_BACKUP_DIR%/}/${INITIAL_NAME}"
daily_path="${HOST_BACKUP_DIR%/}/${DAILY_NAME}"

if [[ ! -f "$initial_path" ]]; then
  create_archive "$initial_path"
fi

create_archive "$daily_path"
echo "Backup done: initial=$(basename "$initial_path"), daily=$(basename "$daily_path")"
