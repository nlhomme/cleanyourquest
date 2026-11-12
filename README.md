# quest2

Make a **Meta Quest 2** silent towards Meta's servers while keeping it usable: local apps, sideloading by
`adb` or SideQuest, and SteamVR over ALVR. Meta's non-essential packages are disabled the reversible way
(`pm disable-user`, never uninstalled), and the headset is cut off from Meta at the network.

This is not part of the CleanYourTV TV project; it reuses its idea on a different device.

## What you lose, what you keep

| Lost | Kept |
|---|---|
| The Meta store, the feed, social features, system updates | Local and sideloaded apps |
| Store-bought games whose licence check fails offline | ADB and SideQuest (USB or LAN) |
| Link and Air Link | SteamVR, over ALVR on your LAN |

The account cannot be removed from the headset; it simply never reaches Meta again.

## The steps

Numbered in the order you need them. See [documentation/](documentation/) for the detail.

| Step | What |
|---|---|
| [01 - Overview](documentation/01-overview.md) | What this does and the two-layer approach |
| [02 - Prerequisites](documentation/02-prerequisites.md) | Headset state, ADB, the PC |
| [10 - Back up](documentation/10-backup.md) | Record the headset before any change |
| [11 - ALVR](documentation/11-alvr.md) | Sideload ALVR and prove SteamVR |
| [20 - Debloat](documentation/20-debloat.md) | Disable Meta's packages in tiers; the scripts |
| [30 - Router block](documentation/30-router-block.md) | Cut the headset off at the router (recommended) |
| [31 - AdGuard Home](documentation/31-adguard.md) | DNS block, for a router that cannot block one device |
| [40 - Verify and restore](documentation/40-verify-and-restore.md) | Confirm it worked; how to undo |
| [50 - Limits](documentation/50-limits.md) | What none of this can do |

## The files here

| File | What it is |
|---|---|
| [`PROMPT.md`](PROMPT.md) | A paste-in prompt so a coding agent can do all of this on another Quest 2 |
| [`debloat.txt`](debloat.txt) | The package list, in tiers, applied by the scripts |
| [`disable.sh`](disable.sh), [`restore.sh`](restore.sh) | Disable the list over USB ADB, and undo it |
| [`adguard-rules.txt`](adguard-rules.txt) | The Meta domain block list for Option B |

Tested on a Quest 2, Horizon OS on Android 14, build `UP1A.231005.007.A1`.

## Status (this headset)

Done: backup taken; ALVR client sideloaded; Tier 1 (25 packages) disabled, shell still Home; updater put
on the restrict-background blacklist and the current Wi-Fi marked metered as a weak extra lock.

Left: set the router WAN block at home and confirm ADB + ALVR over LAN; install the ALVR streamer on the PC
and test SteamVR over Wi-Fi and USB; disable Link/Air Link once ALVR is proven; work through Tier 2 one
package at a time.
