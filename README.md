# 🦾 SlimeVR Server + Web GUI in Docker

![Stars](https://img.shields.io/github/stars/madkoding/docker-slimevr-web-server) ![Forks](https://img.shields.io/github/forks/madkoding/docker-slimevr-web-server) [![Publish Status](https://github.com/madkoding/docker-slimevr-web-server/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/madkoding/docker-slimevr-web-server/actions/workflows/docker-publish.yml) ![Docker Pulls](https://img.shields.io/docker/pulls/madkoding/slimevr-web-server)

This project contains a complete Docker environment to run the [SlimeVR Server](https://github.com/SlimeVR/SlimeVR-Server) with a dynamic Web GUI, ideal for headless setups like Raspberry Pi, home servers, or LAN PCs.

## 🚀 Features

- Automatic download of `.jar` and Web GUI assets from GitHub
- Fully configurable via `.env` file
- Web GUI served through Nginx
- Auto-redirects with `?ip=<your-host-ip>`
- All relevant ports exposed (SlimeVR, VMC, OSC, etc.)
- Simple and production-ready setup 💯

---

## 📁 Project structure

```
slimevr-docker/
├── .env
├── docker-compose.yml
├── nginx/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   └── templates/
│       └── default.conf.template
├── slimevr/
│   └── Dockerfile
```

---

## ⚙️ Configuration

Edit the `.env` file:

```env
SLIMEVR_VERSION=0.14.1         # SlimeVR Server version to download
WEBGUI_PORT=8080               # Port to serve the Web GUI
```

---

## 🧱 Build & Run

```bash
docker compose --env-file .env build
docker compose --env-file .env up -d
```

Then open in your browser:

```
http://<SLIMEVR_IP>:<WEBGUI_PORT>/
```

→ It will redirect automatically to:

```
http://<SLIMEVR_IP>:<WEBGUI_PORT>/?ip=<SLIMEVR_IP>
```

---

## 🌐 Web GUI

The GUI is served through Nginx and is downloaded automatically from:

- [slimevr.jar](https://github.com/SlimeVR/SlimeVR-Server/releases)
- [slimevr-gui-dist.tar.gz](https://github.com/SlimeVR/SlimeVR-Server/releases)

---

## 🧩 Exposed Ports

| Service         | Port(s)       | Protocol |
|------------------|---------------|----------|
| SlimeVR Trackers | 6969          | UDP      |
| Web GUI          | `WEBGUI_PORT` | TCP      |
| WebSocket Bridge | 21110         | TCP      |
| OSC Router       | 9000, 9002     | TCP/UDP  |
| VRC OSC          | 9000, 9001     | TCP/UDP  |
| VMC              | 39539, 39540   | TCP/UDP  |

---

## 🗂 Volumes

- `slimevr-config`: Persistent SlimeVR config (`vrconfig.yml`)
- `slimevr-gui`: Static files for the GUI served by Nginx

---

## 🧪 Troubleshooting

- **ERR_TOO_MANY_REDIRECTS**: Make sure the Nginx redirect only happens if `?ip=` is missing in the URL.
- **Nginx crash with “server directive not allowed”**: Don't overwrite `nginx.conf` with a `server {}` block. Use `conf.d/default.conf` instead.
- **USB not detected**: Check you're mapping the correct port (e.g. `/dev/ttyUSB0`). Adjust it based on your hardware.

---

## 🧡 Credits

- [SlimeVR](https://slimevr.dev/)
- Web GUI based on [slimevr-gui-dist](https://github.com/SlimeVR/SlimeVR-Server/releases)

---

## 📝 License

MIT

---

## Donations

BTC: bc1qrd3mexqu43qn0597d248725kdp3tr28252q64p

<!-- AUTO-UPDATE-DATE -->
**Última actualización:** 2026-02-22 19:05:52 -03
