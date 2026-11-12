# Quest 2: silent towards Meta

Tested on a Quest 2, Horizon OS on Android 14, build `UP1A.231005.007.A1`.

The headset stays set up with its account, which cannot be removed. Meta's non-essential packages are
disabled (never uninstalled), and the headset is cut off from Meta's servers at the network. Sideloading
by `adb` or SideQuest keeps working, and SteamVR goes through ALVR (not Link or Air Link), because both
run over your LAN and need no internet.

There are two ways to cut the headset off, in order of preference:

- **Router WAN block (recommended).** Block the headset from the internet (WAN) at the router while the
  LAN stays up. One setting, no server to run, and it stops even fixed-IP connections that a DNS filter
  misses. See [Option A](#option-a-router-wan-block-recommended).
- **DNS block with AdGuard Home (fallback).** For a router that cannot block a single device. It stops
  lookups by name, not an app that dials a fixed address. See
  [Option B](#option-b-adguard-home-dns-block).

Everything the headset needs for your use — local apps, ADB/SideQuest, ALVR streaming — is LAN or USB,
so cutting WAN costs nothing but the Meta store, the feed and updates.

## What you lose

- The Meta store, the feed, social features, system updates.
- Store-bought games check their licence with Meta. Many keep running offline; some may refuse to start.
- Link, Air Link and anything bought on the store for PC streaming (Virtual Desktop, Steam Link).

## Before you start

- Developer mode on, headset on USB, `adb devices` shows it as `device`.
- A PC with SteamVR, on Windows or Linux, for ALVR.

## Steps

1. **Back up.**
   ```sh
   mkdir -p backup/quest2
   adb shell pm list packages -f > backup/quest2/packages.txt
   adb shell pm list packages -d > backup/quest2/disabled.txt
   adb shell getprop > backup/quest2/getprop.txt
   for n in global secure system; do adb shell settings list $n > backup/quest2/settings-$n.txt; done
   ```
2. **ALVR, while Meta is still reachable.** Sideload `alvr_client_android.apk` from
   <https://github.com/alvr-org/ALVR/releases> with `adb install`, install the streamer of the same
   version on the PC, and check SteamVR over Wi-Fi and over USB (the streamer's wired mode). ALVR is under
   Library > Unknown sources.
3. **Cut the headset off from Meta** with Option A or Option B below.
4. **Disable**, tier 1 first: `quest2/disable.sh quest2/debloat.txt`. It checks the shell after each
   package and stops if Home changed. Put the headset on and check the shell, the library, one app, the
   controllers and the guardian.
5. **Tier 2**, one package at a time: uncomment one line, run the script again, test, go on. If something
   breaks, `adb shell pm enable <package>`.
6. **Check.** With Option A, confirm ADB and ALVR still reach the headset over the LAN and that the
   headset shows "no internet." With Option B, use the headset for a session with AdGuard's query log
   filtered on `quest2`; any Meta name that got an answer goes into the rules.

## Option A: router WAN block (recommended)

Find the headset's Wi-Fi MAC and IP on the network it uses:

```sh
adb shell ip addr show wlan0 | grep -E 'link/ether|inet '
```

1. On the headset, open the Wi-Fi network's settings and set **MAC address type = "Use device MAC"**, so
   the address does not rotate and break the rule. (Check this first; the MAC above must be the hardware
   OUI MAC, where the first octet's second-lowest bit is 0 — e.g. `2c:...`, not a random `x2/x6/xA/xE:`.)
2. In the router admin, give the headset a **fixed DHCP lease** (bind its MAC to its IP).
3. Block **internet (WAN) access for that device**. On a Livebox this is *Contrôle parental → Accès à
   Internet*; it blocks WAN only and leaves the LAN up, so ADB, SideQuest and ALVR keep working.

Limits:

- **This network only.** The rule lives on the router; on any other Wi-Fi or a phone hotspot the headset
  reaches Meta freely. Keep it off those.
- **MAC must stay "device MAC."** A randomized MAC makes the rule fail open.
- **Time drift.** The block also cuts `time.android.com`, so the clock may drift over weeks; it resyncs if
  you ever briefly allow internet.
- The headset will show "no internet" warnings; local apps and streaming still work.

## Option B: AdGuard Home (DNS block)

For a router that cannot block a single device. Install AdGuard Home on a machine that is on when the
headset is, add the headset as a client named `quest2`, paste [`adguard-rules.txt`](adguard-rules.txt)
into the custom filtering rules, and make AdGuard the headset's only DNS server (the router's DHCP
setting, or a static DNS in the headset's Wi-Fi advanced settings). With one DNS server and no fallback,
AdGuard switched off means no lookups at all, not lookups that reach Meta. This stops lookups by name, not
an app that dials a fixed address.

## Status (this headset)

Done: backup taken; ALVR client sideloaded; Tier 1 (25 packages) disabled, shell still Home; updater put
on the restrict-background blacklist and the current Wi-Fi marked metered as a weak extra lock.

Left:

- [ ] Set the router WAN block (Option A) at home, then confirm ADB + ALVR still reach the headset over LAN.
- [ ] Install the ALVR streamer on the PC and test SteamVR over Wi-Fi and USB.
- [ ] Disable Link/Air Link (`com.oculus.xrstreamingclient`, `com.meta.pclinkservice.server`) once ALVR is proven.
- [ ] Work through Tier 2, one package at a time, testing after each.

## The updater, which the OS will not let you disable

`com.oculus.updater` and `com.oculus.q4bservice` are on Horizon OS's protected list: `pm disable-user`
refuses them ("Cannot disable a protected package") and no ADB permission overrides it. The network cutoff
(Option A or B) is what really stops updates — the headset cannot reach Meta's update servers. As a weak
extra lock, with no root:

```sh
UID=$(adb shell dumpsys package com.oculus.updater | grep -m1 -oE 'userId=[0-9]+' | cut -d= -f2)
adb shell cmd netpolicy add restrict-background-blacklist $UID       # deny background data
adb shell cmd netpolicy set metered-network "<your wifi ssid>" true  # make the above bite on this wifi
```

This only limits *background* data on a *metered* network, so it is a belt-and-suspenders measure, not a
real block. Undo:

```sh
adb shell cmd netpolicy remove restrict-background-blacklist $UID
adb shell cmd netpolicy set metered-network "<your wifi ssid>" false
```

## Undo

`quest2/restore.sh quest2/debloat.txt` re-enables everything in the list, and removing the rules from
AdGuard lifts the block. See above for undoing the updater's netpolicy entries.

## Limits

- Option B (DNS) does not stop an app that contacts a fixed address without a lookup. Option A (router
  WAN block) does, which is why it is preferred.
- A factory reset undoes everything, and setting the headset up again needs Meta's servers and the
  account. It is the only way back if the shell and `adb` are both lost, which is why tier 2 goes one
  package at a time.
- Developer mode is granted by Meta; whether it survives indefinitely without contact is not known.
