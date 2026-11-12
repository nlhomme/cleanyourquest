# 01 - Overview

The headset stays set up with its account, which cannot be removed. Everything you use runs over the LAN or
USB, so the headset does not need the internet: local and sideloaded apps, ADB and SideQuest, and SteamVR
through ALVR, which streams headset-to-PC on your own network.

## The two layers

Making the headset silent towards Meta takes two layers, because neither alone is enough.

| Layer | What it does | Why it is not enough alone |
|---|---|---|
| **Disable Meta's packages** ([20](20-debloat.md)) | Removes the store, feed and social UI, and stops much of the local chatter | Horizon OS refuses to disable some packages (the updater), and disabling does not stop a running service from talking |
| **Cut the headset off at the network** ([30](30-router-block.md) or [31](31-adguard.md)) | Stops the packages that keep running from reaching Meta | Does not reduce what is installed or what tries to run |

The network cutoff is the layer that actually enforces "no Meta servers". The debloat makes the headset
tidier and quieter, and is reversible in one command.

## What you lose

- The Meta store, the feed, social features, and system updates.
- Store-bought games check their licence with Meta; many keep running offline, but some may refuse to start.
- Link and Air Link, and anything bought on the store for PC streaming.

## What you keep

- Local and sideloaded apps.
- ADB and SideQuest, over USB or the LAN.
- SteamVR, through ALVR ([11](11-alvr.md)), over Wi-Fi or USB.
