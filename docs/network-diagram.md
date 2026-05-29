# Network Topology

## Overview
[Internet]
│
│  Public IP (dynamic, updated via DuckDNS every 5 min)
│
[Router]
│  Port forwarding: 443 → <server-LAN-IP>:443
│
[Ubuntu Server — <server-LAN-IP>]
│
├── UFW Firewall (allows: 22, 443)
├── Nginx (SSL termination, reverse proxy)
│     └── → Immich :2283 (Docker)
├── Fail2ban (bans brute-force IPs)
├── dnsmasq (Split DNS — local devices resolve domain to LAN IP)
└── Tailscale (VPN — WireGuard, for remote SSH)

## Why Split DNS?

The Telia router doesn't support NAT loopback (hairpin NAT).
This means local devices couldn't reach the server using the public domain — the request would loop on the router.

**Solution:** `dnsmasq` runs on the server and resolves `<your-domain>.duckdns.org` → `<server-LAN-IP>` locally.
Local devices point their DNS to `<server-LAN-IP>` so they always take the LAN path.

## Device DNS Config

| Device | DNS configured |
|--------|---------------|
| Android (user 1) | ✅ Static IP + DNS `<server-LAN-IP>` |
| iPhone (user 2) | ✅ DNS `<server-LAN-IP>` |
| Windows laptop | ✅ DNS `<server-LAN-IP>` |

## Remote Access

SSH via Tailscale (no port 22 exposed to internet):

```bash
ssh <user>@<tailscale-ip>
```
