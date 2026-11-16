# Prompt: make a Meta Quest 2 silent towards Meta

Paste this to a coding agent (Claude Sonnet or better) started in this repository, on a computer that can
run `adb` with the headset connected by USB. The agent does the on-device work; you do the two steps it
cannot (router, PC). Read the rules before you start — they are not optional.

---

You are helping me cut my **Meta Quest 2** off from Meta's servers while keeping it usable: local apps,
sideloading by `adb`/SideQuest, and SteamVR over **ALVR** (which runs on my LAN, not the internet). I accept
losing the Meta store, the feed, system updates, and any store-bought game whose licence check fails offline.

Everything you need is already in this repository: `disable.sh`, `restore.sh`, `debloat.txt`,
`adguard-rules.txt`, and one article per step in `documentation/`. Before each step, read the article named
in that step.

## How to work

- Do **one step per turn**, in order. Run only the commands written in that step.
- After each step, show me the output that matters, say whether it matches the "Expect" line, then **stop
  and wait** for me to answer "ok" before the next step.
- If an output does not match its "Expect" line, stop and show it to me. Do not try a fix on your own and do
  not run the same command again.
- If you are not sure whether something is allowed, it is not. Ask me.

## Rules (do not break these)

- **Disable, never uninstall.** Packages are only disabled through `./disable.sh`. Never run
  `pm uninstall`, `pm clear`, `adb root`, `adb reboot`, `fastboot`, or a factory reset.
- **Do not write or edit scripts.** The only file you may edit is `debloat.txt`, and only to add or remove
  the `# ` in front of one existing package line. Never add a package that is not already in the file.
- **Never work around `disable.sh`.** If it prints `refused, the headset needs it`, stop and tell me. Do not
  run `pm disable-user` by hand for that package.
- **Some packages the OS itself refuses.** If the output contains `Cannot disable a protected package`, the
  script stops there. Put `# ` back in front of that line in `debloat.txt`, tell me which package it was,
  and wait. The network cutoff handles those.
- **Stop and tell me** if `adb devices` no longer shows the headset, or if `disable.sh` prints
  `stopped after`.
- **Never commit or publish identifiers.** The MAC, IP, Wi-Fi name, account email and serial may appear in
  your messages to me and in `backup/` (git-ignored), nowhere else. Do not run `git add`, `git commit` or
  `git push`.

## Steps

### 1. Check the device

Article: `documentation/02-prerequisites.md`.

```sh
adb devices
adb shell getprop ro.product.model
adb shell getprop ro.build.version.release
adb shell pm list packages -d | wc -l
ls backup/quest2 2>/dev/null
```

Expect: one line ending in `device`, then `Quest 2`, then the Android version.

- `unauthorized`: ask me to put the headset on and accept "Allow USB debugging?", then wait.
- Model is not `Quest 2`: stop, this procedure is not for that headset.
- The disabled count is above 0, or `backup/quest2` already has files: this headset was started before.
  Tell me, and ask which step to resume from.

### 2. Back up

Article: `documentation/10-backup.md`. Skip this step if `backup/quest2/packages.txt` already exists: a
second backup would record the changed headset over the original one.

```sh
mkdir -p backup/quest2
adb shell pm list packages -f > backup/quest2/packages.txt
adb shell pm list packages -d > backup/quest2/disabled.txt
adb shell getprop > backup/quest2/getprop.txt
for n in global secure system; do adb shell settings list $n > backup/quest2/settings-$n.txt; done
wc -l backup/quest2/*
```

Expect: `packages.txt` has more than 100 lines; `getprop.txt` and the three settings files are not empty.
`disabled.txt` may be empty.

### 3. Sideload ALVR

Article: `documentation/11-alvr.md`.

```sh
curl -fL -o alvr_client_android.apk https://github.com/alvr-org/ALVR/releases/latest/download/alvr_client_android.apk
adb install alvr_client_android.apk
adb shell pm list packages | grep -i alvr
```

Expect: `Success`, then one `package:` line. Then run
`adb shell dumpsys package <that package> | grep versionName` and tell me the version.

Now it is my turn: I install the ALVR streamer **of that exact version** on my PC and test SteamVR over
Wi-Fi and over USB. Wait until I say that both work.

### 4. Cut the headset off from Meta

I do this step; you guide and then verify. Ask me which of the two I use.

**Router block (preferred).** Article: `documentation/30-router-block.md`.

```sh
adb shell ip addr show wlan0 | grep -E 'link/ether|inet '
```

Give me the MAC and the IP, then read me the three "Set it up" points of the article. Once I say it is done,
ask me to reconnect the headset to the Wi-Fi and run the same command again.

Expect: the same MAC as before. If it changed, the headset is not on "Use device MAC": tell me.

```sh
adb shell ping -c 3 -W 2 1.1.1.1
```

Expect: `100% packet loss`. If a ping is answered, the block is not working: tell me.

**AdGuard Home (fallback).** Article: `documentation/31-adguard.md`. Read me the four "Set it up" points.
You cannot verify this one from here; ask me to check the AdGuard query log as the article's "Check it"
section describes, and wait for my answer.

### 5. Disable Tier 1

Article: `documentation/20-debloat.md`.

```sh
./disable.sh debloat.txt
adb shell pm list packages -d | wc -l
```

Expect: one `new state: disabled-user` line per package, a last line starting with `done.`, and a count
above 20.

Now ask me to put the headset on and check five things: the home environment, the library, one app, the
controllers, the guardian. The store and the feed showing errors is expected. Wait for my answer.

### 6. Disable Link and Air Link

Only if I confirmed in step 3 that SteamVR works over ALVR. Ask me again before you start.

For each of `com.oculus.xrstreamingclient`, then `com.meta.pclinkservice.server`: remove the `# ` in front
of that one line in `debloat.txt`, run `./disable.sh debloat.txt`, and wait for my "ok". The script goes
through the whole list again; packages that are already disabled print the same state, which is normal.

### 7. Tier 2, one package at a time

Ask me which Tier 2 package I want next; do not choose yourself. Then, for that one package only: remove the
`# ` in front of its line in `debloat.txt`, run `./disable.sh debloat.txt`, ask me to test the headset as in
step 5, and wait.

If I say something broke: run `adb shell pm enable <that package>`, put the `# ` back in front of its line,
and tell me.

### Undo, any time I ask

Article: `documentation/40-verify-and-restore.md`.

```sh
./restore.sh debloat.txt
adb shell pm list packages -d | wc -l
```

Then remind me to remove the router block or the AdGuard rules myself.

Start at step 1.
