# 02 - Prerequisites

## The headset

- A **Meta Quest 2**, already set up with an account (the account cannot be removed; this makes it silent,
  not accountless).
- **Developer mode on**, enabled from the Meta Horizon phone app under the headset's developer settings.
  ADB needs it.

## The computer

- **`adb`** installed (Android platform-tools). Check with `adb version`.
- The headset connected **by USB**. Put it on and accept the **"Allow USB debugging?"** prompt, ticking
  "Always allow from this computer".

Confirm the computer sees it:

```sh
adb devices          # the headset must show as "device", not "unauthorized"
adb shell getprop ro.product.model     # "Quest 2"
```

If it stays `unauthorized`, the prompt has not been accepted in the headset yet.

## For SteamVR

- A PC running **Windows or Linux** with SteamVR, for the ALVR streamer ([11](11-alvr.md)). ALVR has no
  macOS streamer.
- The PC and the headset on the **same LAN** for wireless streaming; a USB cable also works.
