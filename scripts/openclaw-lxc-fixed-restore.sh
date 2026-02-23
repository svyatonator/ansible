#!/usr/bin/env bash
set -Eeuo pipefail

LXC_NAME="${LXC_NAME:-openclaw}"
HOST_BACKUP_DIR="${HOST_BACKUP_DIR:-/srv/openclaw/backup-fixed}"
ARCHIVE_PATH="${ARCHIVE_PATH:-${HOST_BACKUP_DIR}/openclaw-daily.tar.gz}"
TMP_ARCHIVE_IN_CONTAINER="${TMP_ARCHIVE_IN_CONTAINER:-/tmp/openclaw-restore.tar.gz}"
CREATE_PRE_RESTORE_BACKUP="${CREATE_PRE_RESTORE_BACKUP:-true}"

usage() {
  cat <<'EOF'
Usage:
  openclaw-lxc-fixed-restore.sh [--archive /path/to/archive.tar.gz] [--no-pre-backup]

Defaults:
  Restores from /srv/openclaw/backup-fixed/openclaw-daily.tar.gz

Environment overrides:
  LXC_NAME, HOST_BACKUP_DIR, ARCHIVE_PATH, TMP_ARCHIVE_IN_CONTAINER,
  CREATE_PRE_RESTORE_BACKUP
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --archive)
      ARCHIVE_PATH="${2:-}"
      shift 2
      ;;
    --no-pre-backup)
      CREATE_PRE_RESTORE_BACKUP=false
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root." >&2
  exit 1
fi

for cmd in lxc tar date; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing required command: $cmd" >&2
    exit 1
  fi
done

if [[ ! -f "$ARCHIVE_PATH" ]]; then
  echo "Archive not found: $ARCHIVE_PATH" >&2
  exit 1
fi

if ! lxc info "$LXC_NAME" >/dev/null 2>&1; then
  echo "Container '$LXC_NAME' not found." >&2
  exit 1
fi

if ! lxc list "$LXC_NAME" --format csv -c s | grep -q "^RUNNING$"; then
  lxc start "$LXC_NAME" >/dev/null
fi

if [[ "$CREATE_PRE_RESTORE_BACKUP" == "true" ]]; then
  mkdir -p "$HOST_BACKUP_DIR"
  pre_restore_archive="${HOST_BACKUP_DIR}/openclaw-pre-restore-$(date +%F-%H%M%S).tar.gz"
  lxc exec "$LXC_NAME" -- bash -lc "
    set -e
    files=(srv/openclaw)
    for f in \
      etc/systemd/system/openclaw.service \
      etc/systemd/system/openclaw-backup.service \
      etc/systemd/system/openclaw-backup.timer; do
      [[ -e \"/\$f\" ]] && files+=(\"\$f\")
    done
    tar -C / -czf - \"\${files[@]}\"
  " >"$pre_restore_archive"
  echo "Created pre-restore backup: $pre_restore_archive"
fi

lxc exec "$LXC_NAME" -- bash -lc "systemctl stop openclaw.service || true"
lxc file push "$ARCHIVE_PATH" "${LXC_NAME}${TMP_ARCHIVE_IN_CONTAINER}"
lxc exec "$LXC_NAME" -- bash -lc "tar -xzf ${TMP_ARCHIVE_IN_CONTAINER} -C /"
lxc exec "$LXC_NAME" -- bash -lc "rm -f ${TMP_ARCHIVE_IN_CONTAINER}"
lxc exec "$LXC_NAME" -- bash -lc "systemctl daemon-reload || true"
lxc exec "$LXC_NAME" -- bash -lc "systemctl enable --now openclaw.service"
lxc exec "$LXC_NAME" -- bash -lc "systemctl enable --now openclaw-backup.timer || true"

echo "Restore completed from: $ARCHIVE_PATH"
