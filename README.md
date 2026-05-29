🖥️ Home Server — Self-Hosted Cloud Infrastructure
> A personal cloud server built on a 2013 Samsung laptop, running Ubuntu 24.04 LTS with Docker, Nginx, SSL, VPN, and automated security hardening.
This is a hands-on homelab project I built alongside my Cloud Security and Infrastructure studies at Noroff University College (Norway). I'm early in my journey, but instead of just reading about Linux, Docker, and networking — I'd rather spin up a real server and figure it out hands-on. The goal was to build a production-like environment at home — with proper security, HTTPS, reverse proxy, firewall, and remote access — using consumer hardware.
---
📐 Architecture Overview
```
Internet
   │
   ▼
Router (Port Forward 443 only)
   │
   ▼
Nginx (Reverse Proxy + SSL Termination)
   │
   ├── HTTPS → Immich (Photo Cloud) :2283
   │
UFW Firewall (ports: 22, 443)
Fail2ban (SSH + Nginx brute-force protection)
Tailscale (VPN — secure remote SSH access)
DuckDNS (Dynamic DNS — updates every 5 min via cron)
dnsmasq (Split DNS — solves NAT loopback issue)
```
---
🔧 Hardware

Component	Details
Device	Samsung 355V4C (2013)
CPU	AMD A8-4500M @ 1.90 GHz
RAM	6 GB
Storage	Kingston SSD 120 GB
OS	Ubuntu 24.04.4 LTS
Network	Qualcomm Atheros AR9485 (WiFi)

---
🚀 Services
Immich — Self-Hosted Photo Cloud
Google Photos alternative, runs in Docker
Accessible at `https://<your-domain>`
Containers: `immich_server`, `immich_postgres`, `immich_redis`, `immich_machine_learning`
Nginx — Reverse Proxy
Terminates SSL (Let's Encrypt)
Forwards HTTPS → Immich on internal port 2283
WebSocket support for real-time sync
Security headers: HSTS, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, Permissions-Policy
Fail2ban — Intrusion Prevention
Bans IPs after 5 failed attempts within 10 minutes (1h ban)
Active jails: `sshd`, `nginx-http-auth`
Tailscale — VPN
Secure remote SSH access without exposing port 22 to the internet
WireGuard-based, zero-config
DuckDNS — Dynamic DNS
Updates public IP every 5 minutes via cron job
Keeps domain pointing to dynamic ISP IP
dnsmasq — Split DNS
Solves NAT loopback (router doesn't support hairpin NAT)
Local devices resolve the domain directly to the server's LAN IP
---
🔒 Security
Layer	Tool	Status
Firewall	UFW	✅ Active (443, 22)
Brute-force protection	Fail2ban	✅ Active
HTTPS	Let's Encrypt + Nginx	✅ A+ (SSL Labs)
Security headers	Nginx	✅ A (SecurityHeaders.com)
Remote access	Tailscale VPN	✅ Active
Auto security updates	unattended-upgrades	✅ Active
SSL Labs score: A+
SecurityHeaders.com score: A
---
📁 Repository Structure
```
homeserver/
├── configs/
│   ├── nginx/
│   │   └── immich.conf          # Nginx reverse proxy config
│   ├── fail2ban/
│   │   └── jail.local           # Fail2ban jail config
│   └── docker/
│       └── docker-compose.yml   # Immich Docker Compose (sanitized)
├── scripts/
│   ├── backup-immich-db.sh      # Postgres database backup
│   ├── renew-ssl.sh             # Let's Encrypt SSL renewal
│   └── update-duckdns.sh        # Manual DuckDNS IP update
├── docs/
│   └── network-diagram.md       # Network topology notes
├── .env.example                 # Environment variables template
├── .gitignore
└── README.md
```
---
⚙️ Setup Guide
Prerequisites
Ubuntu 24.04 LTS
- Docker (with Compose v2 plugin)
A domain (e.g. DuckDNS)
Router with port forwarding (443)
Quick Start
```bash
# 1. Clone the repo
git clone https://github.com/YOUR_USERNAME/homeserver.git
cd homeserver

# 2. Copy and fill in your secrets
cp .env.example .env
nano .env

# 3. Start Immich
cd configs/docker
docker compose up -d

# 4. Configure Nginx
sudo cp configs/nginx/immich.conf /etc/nginx/sites-available/immich
sudo ln -s /etc/nginx/sites-available/immich /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# 5. Set up DuckDNS cron
sudo cp scripts/update-duckdns.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/update-duckdns.sh
# Add to crontab: */5 * * * * /usr/local/bin/update-duckdns.sh
```
---
🗺️ Roadmap

[x] Immich photo cloud (Docker)

[x] Nginx reverse proxy with SSL (A+ rating)

[x] Fail2ban brute-force protection

[x] Tailscale VPN remote access
[x] DuckDNS dynamic DNS
[x] Split DNS with dnsmasq
[x] Security headers (HSTS, etc.)
[x] Unattended security upgrades
[ ] External 2TB drive for photo storage
[ ] Immich database automated backup
[ ] Seafile (file sync like Dropbox)
[ ] GitHub Actions — automated config linting
---
📚 What I Learned
Reverse proxy setup and SSL termination with Nginx
Docker networking and container orchestration
Network security layers (UFW, Fail2ban, VPN)
Dynamic DNS and NAT loopback troubleshooting
Split DNS configuration with dnsmasq
Linux system hardening on resource-constrained hardware
---
⚠️ Disclaimer
This repo contains sanitized configuration files. All secrets (tokens, IPs, passwords) have been removed and replaced with placeholders. See `.env.example` for required variables.
---
📄 License
MIT — feel free to use this as a reference for your own home server setup.
