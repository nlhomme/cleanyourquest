# 30 - Router block (recommended)

Block the headset from the **internet (WAN)** at the router, while the **LAN** stays up. This is the
preferred cutoff: one setting, no server to run, and it stops even an app that dials a fixed address, which
a DNS block ([31](31-adguard.md)) misses. Everything you use — ADB, SideQuest, ALVR — is LAN or USB, so it
keeps working.

## Find the headset's address

```sh
adb shell ip addr show wlan0 | grep -E 'link/ether|inet '
```

This gives the Wi-Fi MAC (`link/ether`) and the IP (`inet`).

## Set it up

1. On the headset, open the Wi-Fi network's settings and set **MAC address type = "Use device MAC"**, so
   the address does not rotate and break the rule. It must be the hardware OUI MAC — the first octet's
   second-lowest bit is 0 (e.g. `2c:…`), not a random `x2/x6/xA/xE:…`.
2. In the router admin, give the headset a **fixed DHCP lease** (bind its MAC to its IP).
3. Block **internet (WAN) access for that device**. On a Livebox this is **Contrôle parental → Accès à
   Internet**; it blocks WAN only and leaves the LAN up.

## Check it

- `adb devices` and ALVR still reach the headset over the LAN.
- The headset shows a "no internet" warning; local apps and streaming still work.

## Limits

- **This network only.** The rule lives on the router; on any other Wi-Fi or a phone hotspot the headset
  reaches Meta freely. Keep it off those.
- **MAC must stay "device MAC."** A randomized MAC makes the rule fail open.
- **Time drift.** The block also cuts `time.android.com`, so the clock may drift over weeks; it resyncs if
  you ever briefly allow the internet.
