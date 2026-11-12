# Documentation

The articles are numbered in the order you need them to clean up a Quest 2.

## Before you start

- [01 - Overview](01-overview.md): what this does, what you lose, and the two layers that do the work
- [02 - Prerequisites](02-prerequisites.md): the headset's state, ADB over USB, and the PC for SteamVR

## The steps

In order. Each article follows the same plan: what the step is for, the commands, and how to check it.

- [10 - Back up](10-backup.md)
- [11 - ALVR](11-alvr.md)
- [20 - Debloat](20-debloat.md)

## Cut the headset off from Meta

Two ways, in order of preference. Only one is needed.

- [30 - Router block](30-router-block.md): block the headset from the internet at the router (recommended)
- [31 - AdGuard Home](31-adguard.md): a DNS block, for a router that cannot block a single device

## Once it is done

- [40 - Verify and restore](40-verify-and-restore.md): confirm Meta is unreachable; how to undo everything
- [50 - Limits](50-limits.md): what none of this can do

## Principles common to every step

- **Disable, never uninstall.** Only `pm disable-user --user 0`, one package per call. No root (the Quest 2
  cannot be rooted), nothing flashed. Everything is undone by [`restore.sh`](../restore.sh).
- **Back up before the first change**, and never commit the backup or any device identifier (MAC, IP,
  Wi-Fi name, account email, serial).
- **Work in small batches** and check the headset between them.
- **Stop** if the shell stops being Home, if ADB drops, or if `pm disable-user` is refused for a package
  not on the protected list. Do not retry in a loop.
