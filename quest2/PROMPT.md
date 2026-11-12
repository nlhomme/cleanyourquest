# Prompt: make a Meta Quest 2 silent towards Meta

Paste this to a coding agent (Claude Opus or similar) that can run `adb` on a computer with the headset
connected by USB. The agent does the on-device work; you do the two steps it cannot (router, PC). Read the
rules before you start — they are not optional.

---

You are helping me cut my **Meta Quest 2** off from Meta's servers while keeping it usable: local apps,
sideloading by `adb`/SideQuest, and SteamVR over **ALVR** (which runs on my LAN, not the internet). I accept
losing the Meta store, the feed, system updates, and any store-bought game whose licence check fails offline.

Use the scripts and lists in this `quest2/` folder. Do not write new ones unless I ask. Work in small steps
and tell me what you see after each.

## Rules (do not break these)

- **Disable, never uninstall.** Only `pm disable-user --user 0 <pkg>`, one package per call. No `pm uninstall`,
  no root (the Quest 2 cannot be rooted anyway), nothing flashed. Everything must be undoable by
  `quest2/restore.sh`.
- **Back up first**, before any change: `adb shell pm list packages -f`, `pm list packages -d`, `getprop`,
  and `settings list {global,secure,system}` into `backup/quest2/` (git-ignored; never commit it).
- **Never disable what the headset needs to work:** the shell (`com.oculus.vrshell`), system UI
  (`com.oculus.systemux`, `com.meta.systemui`), guardian/boundary, tracking and system drivers
  (`com.oculus.systemdriver`, `vendor.oculus.*`), Bluetooth/controller pairing, settings, the library panel,
  the USB service (`com.oculus.os.vrusb`), `horizonos.*`, `horizon.platform.*`, and Android's core
  (`android`, `com.android.*`, `com.qualcomm.*`). `quest2/disable.sh` refuses these; do not override it.
- **Some packages the OS itself refuses** ("Cannot disable a protected package"), e.g. `com.oculus.updater`.
  Do not fight it — the network cutoff below handles those.
- **Stop and tell me** if the shell stops being Home, if ADB drops, or if `pm disable-user` is refused for a
  package not on the protected list. Do not retry in a loop.
- **Never remove or publish identifiers.** No MAC, IP, Wi-Fi name, account email or serial in any committed
  file; use placeholders.

## Steps

1. **Check the device.** `adb devices` must show `device` (I will accept the "Allow USB debugging?" prompt).
   Read the model and Android version with `getprop`. If it is not a Quest 2, stop.
2. **Back up** as above.
3. **Sideload ALVR** while Meta is still reachable: download the latest `alvr_client_android.apk` from
   <https://github.com/alvr-org/ALVR/releases> and `adb install` it. Tell me to install the **same version**
   streamer on my PC and confirm SteamVR works over Wi-Fi and USB before going on.
4. **Cut the headset off from Meta.** Walk me through one of these (I do it, you verify after):
   - **Router WAN block (preferred):** give me the headset's Wi-Fi MAC and IP
     (`adb shell ip addr show wlan0`), have me set the headset's Wi-Fi to **"Use device MAC"**, bind a fixed
     DHCP lease, and block **internet (WAN)** for that device while the LAN stays up. Then confirm ADB and
     ALVR still reach it over the LAN.
   - **AdGuard Home (fallback), for a router that cannot block one device:** I run AdGuard, add the headset as
     a client, and paste `quest2/adguard-rules.txt`; you verify from the query log that no Meta name is
     answered.
   See `quest2/README.md` for the detail and the limits of each.
5. **Disable Tier 1:** `quest2/disable.sh quest2/debloat.txt`. It checks the shell after each package and
   stops if Home changed. Then have me put the headset on and confirm the home environment, library, one app,
   the controllers and the guardian all work. The store/feed showing errors is expected.
6. **Tier 2, one at a time:** uncomment a single line in `quest2/debloat.txt`, run the script again, have me
   test, then go on. If anything breaks, `adb shell pm enable <pkg>`.
7. **Undo, any time:** `quest2/restore.sh quest2/debloat.txt`, and remove the router/AdGuard block.

Start at step 1 and wait for my confirmation between steps that involve the headset on my face.
