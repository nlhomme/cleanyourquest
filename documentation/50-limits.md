# 50 - Limits

- **The account stays on the headset.** It cannot be removed; it just never reaches Meta again. There is no
  supported way to run a Quest 2 with no account, and a factory reset brings the requirement back.
- **A factory reset undoes everything** and needs Meta's servers and the account to set the headset up
  again. It is the only way back if the shell and ADB are both lost — which is why Tier 2 goes one package
  at a time.
- **The Quest 2 cannot be rooted.** Its bootloader is locked and Meta provides no unlock, so there is no
  on-device firewall or way to disable the OS-protected packages. The network cutoff is the substitute, and
  for the "no Meta servers" goal it is as good or better.
- **DNS blocking ([31](31-adguard.md)) misses fixed-address connections.** Only the [router block](30-router-block.md)
  closes that.
- **The router block is per-network.** On another Wi-Fi or a phone hotspot the headset reaches Meta freely.
- **Developer mode is granted by Meta.** Whether it survives indefinitely with no contact is not known.
