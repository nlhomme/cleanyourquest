# 40 - Verify and restore

## Verify

- **Router block ([30](30-router-block.md))**: confirm ADB and ALVR still reach the headset over the LAN,
  and that the headset shows "no internet". The store and feed fail to load.
- **AdGuard ([31](31-adguard.md))**: use the headset for a session with the query log filtered on `quest2`
  and confirm no Meta name is answered.

The store, feed and social tiles failing is the sign it is working, not a fault.

## Restore

```sh
./restore.sh debloat.txt
```

This re-enables every package in the list (commented-out lines too), except those that were already
disabled before the first `disable.sh` run — that state was recorded in `backup/quest2-disabled-before.txt`.

To undo the rest:

- Remove the router WAN block, or delete the rules from AdGuard.
- Undo the updater's metered/background lock ([20](20-debloat.md)):
  ```sh
  UID=$(adb shell dumpsys package com.oculus.updater | grep -m1 -oE 'userId=[0-9]+' | cut -d= -f2)
  adb shell cmd netpolicy remove restrict-background-blacklist $UID
  adb shell cmd netpolicy set metered-network "<your wifi ssid>" false
  ```
