# 10 - Back up

Record the headset before touching anything, so [restore](40-verify-and-restore.md) has something to go
back to. Write it under `backup/quest2/`, which is git-ignored; never commit it.

```sh
mkdir -p backup/quest2
adb shell pm list packages -f > backup/quest2/packages.txt     # every package and its path
adb shell pm list packages -d > backup/quest2/disabled.txt     # already-disabled, so restore leaves them
adb shell getprop > backup/quest2/getprop.txt                  # model, build, properties
for n in global secure system; do
  adb shell settings list $n > backup/quest2/settings-$n.txt
done
```

## Check it

```sh
wc -l backup/quest2/*
```

`packages.txt` should hold a couple of hundred lines. `disabled.txt` is empty on a headset that has never
been debloated, and that is fine — it records the starting point either way.
