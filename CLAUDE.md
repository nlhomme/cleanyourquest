# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A reversible procedure to make a Meta Quest 2 silent towards Meta's servers: two bash scripts, two data
lists, and numbered docs. There is no build, no test suite, no linter and no dependency other than `adb`
and standard Unix tools. Tested on Horizon OS / Android 14, build `UP1A.231005.007.A1`.

## Commands

```sh
./disable.sh debloat.txt     # disable every active line of the list (needs a headset on USB adb)
./restore.sh debloat.txt     # re-enable the list, commented-out lines included
bash -n disable.sh restore.sh   # the only check that runs without a headset
```

Both scripts act on a real device. Do not run them to "test" a change unless the user has a headset
connected and asks for it.

## How the pieces fit

Two layers, neither enough alone (`documentation/01-overview.md`):

1. **Debloat**: `disable.sh` applies `debloat.txt` with `pm disable-user --user 0`, one package per call.
2. **Network cutoff**: a router WAN block (preferred, `documentation/30-router-block.md`) or the AdGuard
   Home DNS rules in `adguard-rules.txt` (fallback). This is the layer that actually enforces "no Meta",
   because Horizon OS refuses to disable some packages (`com.oculus.updater`, `com.oculus.q4bservice`).

Things that span files and must stay consistent:

- **`debloat.txt` is parsed two different ways.** `disable.sh` strips `#` comments and takes the first
  word of each remaining line. `restore.sh` instead matches lines that are a dotted package name,
  optionally prefixed by `#` and optionally followed by a `#` comment, so that commented-out tiers get
  re-enabled too. Consequence: never write a prose comment that is only a dotted word (restore would try
  to enable it).
- **The `PROTECTED` regex in `disable.sh`** is the guard against bricking the headset (shell, system UI,
  guardian, drivers, USB service, `horizonos.*`, Android core). It has no override by design. The same
  list is described in prose in `documentation/20-debloat.md`; change them together.
- **`backup/quest2-disabled-before.txt`** is written once by the first `disable.sh` run and read by
  `restore.sh` to leave alone whatever was already disabled. It is separate from the manual backup in
  `backup/quest2/` (`documentation/10-backup.md`), which no script reads. `backup/` is git-ignored.
- **Tiers** in `debloat.txt`: Tier 1 ships active and is applied at once; the Link/Air Link block and
  Tier 2 ship commented out and are uncommented one line at a time, with a headset test after each. After
  each package `disable.sh` checks that `com.oculus.vrshell` still resolves as Home and stops otherwise.
- **`PROMPT.md`** is a paste-in prompt for an agent repeating the procedure on another headset. It is
  written for a smaller model (Sonnet): exact commands, an "Expect" line per step, one step per turn. It
  copies commands and script messages (`refused, the headset needs it`, `stopped after`, `done.`) from
  `documentation/` and the scripts, so a change to either usually touches the prompt too.
- **Docs numbering** is the order of the steps (`01`-`02` before you start, `10`-`20` on-device, `30`-`31`
  network, `40`-`50` after). A new article needs an entry in both `README.md` and `documentation/README.md`.

## Rules for any change

- Disable, never uninstall. No `pm uninstall`, no root, nothing flashed; everything must be undone by
  `./restore.sh`.
- Never commit a device identifier (MAC, IP, Wi-Fi SSID, account email, serial) or anything from `backup/`.
  Use placeholders such as `<your wifi ssid>`.
- Documentation is in English only.
