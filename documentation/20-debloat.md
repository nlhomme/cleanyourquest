# 20 - Debloat

Disable Meta's non-essential packages, one per call, for user 0. Nothing is uninstalled; [restore](40-verify-and-restore.md)
undoes every step. Use the scripts here, not hand-typed `pm` calls.

## The scripts

```sh
./disable.sh debloat.txt     # disable the list
./restore.sh debloat.txt     # re-enable it (except what was already disabled)
```

`disable.sh` refuses any package the headset needs to boot, track, pair or be reached (the shell, system
UI, guardian, drivers, USB service, `horizonos.*`, Android core), with no override. After each package it
checks that Meta's shell still owns Home and stops if it does not.

## The tiers

[`debloat.txt`](../debloat.txt) is in tiers:

| Tier | What | How to apply |
|---|---|---|
| **Tier 1** | Store, feed, Worlds, social, avatars, assistant, promotions, bug-report, stats, ad-ID, updater stub, work/MDM, Meta TV | All at once; the list ships with these active |
| **Link/Air Link** | `com.oculus.xrstreamingclient`, `com.meta.pclinkservice.server` | Uncomment after ALVR is proven ([11](11-alvr.md)) |
| **Tier 2** | Platform, identity and licence services, the browser, casting, supervision | One line at a time, testing after each |

Tier 2 goes one package at a time because apps may depend on these; if one breaks, `adb shell pm enable
<package>`.

## Packages the OS will not let you disable

Horizon OS keeps its own protected list. `pm disable-user` answers **"Cannot disable a protected package"**
for `com.oculus.updater` (the system updater) and `com.oculus.q4bservice`, and no ADB permission overrides
it. They stay enabled; the [network cutoff](30-router-block.md) is what stops them reaching Meta. These are
commented out in the list with the reason.

## A weak extra lock on the updater (optional)

Without root there is no per-app internet kill (`INTERNET` is not an appop, and `pm revoke` cannot touch
it). The nearest lever denies the updater's **background** data on a **metered** network — a belt-and-
suspenders measure, not a real block; the network cutoff is what matters:

```sh
UID=$(adb shell dumpsys package com.oculus.updater | grep -m1 -oE 'userId=[0-9]+' | cut -d= -f2)
adb shell cmd netpolicy add restrict-background-blacklist $UID
adb shell cmd netpolicy set metered-network "<your wifi ssid>" true
```

Undo:

```sh
adb shell cmd netpolicy remove restrict-background-blacklist $UID
adb shell cmd netpolicy set metered-network "<your wifi ssid>" false
```

## Check it

After Tier 1, put the headset on and confirm the home environment, the library, one app, the controllers
and the guardian all work. The store and feed showing errors is expected — that is the debloat working.

```sh
adb shell pm list packages -d | wc -l     # how many are now disabled
```
