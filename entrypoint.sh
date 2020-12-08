#!/bin/bash
set -euo pipefail

DATA_USER=data
DATA_DIR=/home/data
HOST_KEYS_DIR_PREFIX=/var/local
HOST_KEYS_DIR="$HOST_KEYS_DIR_PREFIX/etc/ssh"

# This won't be executed if keys already exist (i.e. from a volume)
mkdir -p "$HOST_KEYS_DIR"

if [[ -n "${AUTHORIZED_KEYS:-}" ]]; then
  echo "$AUTHORIZED_KEYS" >> "$AUTHORIZED_KEYS_FILE"
else
  >&2 echo "Error! Missing AUTHORIZED_KEYS variable."
  exit 1
fi

if [[ "$(stat -c %U:%G "$DATA_DIR")" != "$DATA_USER:$DATA_USER" ]]; then
  >&2 echo Changing owner of "$DATA_DIR" to "$DATA_USER:$DATA_USER"
  chown "$DATA_USER":"$DATA_USER" "$DATA_DIR"
fi

# Run sshd on container start
exec /usr/sbin/sshd -D -e
