# 31 - AdGuard Home (fallback)

For a router that cannot block a single device. AdGuard Home becomes the headset's only DNS server and
refuses Meta's domains. It stops lookups by name, not an app that dials a fixed address — so the
[router block](30-router-block.md) is stronger where you can use it.

## Set it up

1. Install **AdGuard Home** on a machine that is on whenever the headset is.
2. Add the headset as a **persistent client** named `quest2` (by its MAC address).
3. Paste [`adguard-rules.txt`](../adguard-rules.txt) into **Filters → Custom filtering rules**. The rules
   are scoped to the `quest2` client, so other devices at home keep WhatsApp, Instagram and the rest.
4. Make AdGuard the headset's **only DNS server** — set it in the router's DHCP, or as a static DNS in the
   headset's Wi-Fi advanced settings. With one server and no fallback, AdGuard switched off means no
   lookups at all, not lookups that reach Meta.

## Check it

Use the headset for a session with AdGuard's **query log** filtered on `quest2`. Any Meta name that got an
answer goes into the rules. A correct setup shows every Meta lookup blocked.

## To block Meta for the whole network

Delete every `$client=quest2` from the rules.
