#!/usr/bin/env bash
# Rejects commits that carry a Co-Authored-By trailer.
set -euo pipefail

msg_file="$1"

if grep -qiE '^[[:space:]]*Co-Authored-By:' "$msg_file"; then
  echo "oh, Co-Authored-By? make ABSOLUTELY sure you reviewed these changes, then remove the trailer(s) below before committing:" >&2
  grep -niE '^[[:space:]]*Co-Authored-By:' "$msg_file" | sed 's/^/  /' >&2
  exit 1
fi
