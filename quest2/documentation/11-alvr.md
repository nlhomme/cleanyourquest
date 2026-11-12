# 11 - ALVR

ALVR replaces Link and Air Link for SteamVR. It is open source, sideloads by ADB, and streams over Wi-Fi
or USB without touching Meta. Install and prove it **while Meta is still reachable**, so a streaming problem
is never confused with the debloat or the network cutoff.

## Install the headset client

Download the latest `alvr_client_android.apk` from the ALVR releases page and sideload it:

```sh
# https://github.com/alvr-org/ALVR/releases
adb install alvr_client_android.apk
```

It appears in the headset under **Library > Unknown sources**.

## Install the PC streamer

On the SteamVR PC, install the **ALVR streamer of the same version** as the client (Windows or Linux; there
is no macOS streamer). Match the versions exactly or they refuse to connect.

## Check it

Launch ALVR on the headset, then in the streamer:

- **Wi-Fi**: the headset appears as a trusted client; connect and start SteamVR.
- **USB**: use the streamer's wired mode over the cable.

Confirm SteamVR renders in the headset on both before going on to the debloat. Store-bought PC-streaming
apps (Virtual Desktop, Steam Link) are not used here, since they check their licence with Meta.
