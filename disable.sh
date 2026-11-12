#!/usr/bin/env bash
# Disable every package in a list on a Quest 2 over USB adb. Never uninstalls.
# Checks after each package that adb and Meta's shell still answer, and stops if not.
# Usage: quest2/disable.sh quest2/debloat.txt     Undo: quest2/restore.sh <same list>
set -euo pipefail
export LC_ALL=C
LIST="${1:?usage: disable.sh <list>}"
REC="$(dirname "$0")/../backup/quest2-disabled-before.txt"
# What the headset needs to boot, track, pair and be reached: refused, no override.
PROTECTED='^(android|android\.ext\..*|com\.android\..*|com\.qualcomm\..*|horizonos\..*|horizon\.platform\..*|com\.meta\.systemui|com\.oculus\.(vrshell|systemux|systemdriver|systemactivities|systemutilities|systemresource|guardian.*|os\..*|vrbtcontrol|micservice|userserver2|ocms|configuration|panelapp\.(settings|library|devicepairing)|firsttimenux|MiramarSetupRetail|maintenanceboot|externalstorage|extrapermissions|.*\.rro))$'

PKGS=$(tr -d '\r' < "$LIST" | sed -E 's/#.*$//' | awk 'NF {print $1}')
[ -n "$PKGS" ] || { echo "no package in $LIST"; exit 0; }
for p in $PKGS; do
  [[ "$p" =~ ^[A-Za-z0-9_.]+$ ]] || { echo "not a package name: $p" >&2; exit 1; }
  [[ "$p" =~ $PROTECTED ]] && { echo "refused, the headset needs it: $p" >&2; exit 1; }
done

mkdir -p "$(dirname "$REC")"
# Written once, on the first run: the state restore.sh goes back to.
[ -e "$REC" ] || adb shell pm list packages -d | tr -d '\r' > "$REC"

for p in $PKGS; do
  adb shell pm disable-user --user 0 "$p" | tr -d '\r'
  home=$(adb shell cmd package resolve-activity --brief -c android.intent.category.HOME -a android.intent.action.MAIN | tr -d '\r' | tail -n 1)
  case "$home" in
    com.oculus.vrshell/*) ;;
    *) echo "stopped after $p: Home is now '$home'. Undo with: adb shell pm enable $p" >&2; exit 1 ;;
  esac
done
echo "done. Undo with: quest2/restore.sh $LIST"
