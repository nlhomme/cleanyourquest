#!/usr/bin/env bash
# Re-enable every package in a list (commented-out lines too), except those that
# were already disabled before the first ./disable.sh run.
# Usage: ./restore.sh debloat.txt
set -euo pipefail
export LC_ALL=C
LIST="${1:?usage: restore.sh <list>}"
REC="$(dirname "$0")/backup/quest2-disabled-before.txt"
[ -e "$REC" ] || REC=/dev/null
tr -d '\r' < "$LIST" | grep -oE '^(# *)?[A-Za-z0-9_]+(\.[A-Za-z0-9_]+)+ *$' | tr -d '# ' | while read -r p; do
  grep -qx "package:$p" "$REC" && continue
  adb shell pm enable "$p" < /dev/null | tr -d '\r'
done
