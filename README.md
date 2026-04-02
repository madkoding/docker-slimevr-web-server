# SlimeVR Server + Web GUI (Docker)

![Stars](https://img.shields.io/github/stars/madkoding/docker-slimevr-web-server)
![Forks](https://img.shields.io/github/forks/madkoding/docker-slimevr-web-server)
[![Publish Status](https://github.com/madkoding/docker-slimevr-web-server/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/madkoding/docker-slimevr-web-server/actions/workflows/docker-publish.yml)
![Docker Pulls](https://img.shields.io/docker/pulls/madkoding/slimevr-web-server)

Run [SlimeVR Server](https://github.com/SlimeVR/SlimeVR-Server) and its Web GUI in Docker with a setup that works across Linux, macOS, and Windows, plus an optimized Linux hotplug mode for direct USB tracker usage.

## Features

- Auto-downloads `slimevr.jar` and `slimevr-gui-dist.tar.gz` from official releases
- Single `.env` configuration for version and Web GUI port
- Nginx-served Web GUI with automatic `?ip=` redirect
- Cross-platform default compose profile (Docker Desktop friendly)
- Linux override profile for stable USB/HID hotplug behavior

## Project Structure

```text
.
|- .env
|- docker-compose.yml
|- docker-compose.linux.yml
|- nginx/
|  |- Dockerfile
|  |- entrypoint.sh
|  \- templates/
|     \- default.conf.template
\- slimevr/
   \- Dockerfile
```

## Requirements

- Docker Engine 24+ (or Docker Desktop)
- Docker Compose v2 (`docker compose`)

## Configuration

Edit `.env`:

```env
SLIMEVR_VERSION=19.0.0-rc.1
WEBGUI_PORT=8080
```

## Run

### Option A: Cross-platform default (Linux/macOS/Windows)

```bash
docker compose up -d
```

This mode uses explicit port mappings and is the recommended default for Docker Desktop users.

### Option B: Linux USB hotplug mode (recommended for direct USB trackers)

```bash
docker compose -f docker-compose.yml -f docker-compose.linux.yml up -d
```

This mode enables host networking and mounts `/dev` + `/run/udev` for resilient USB/HID reattach behavior.

## Access the Web GUI

Open:

```text
http://<HOST_IP>:<WEBGUI_PORT>/
```

The GUI auto-redirects to:

```text
http://<HOST_IP>:<WEBGUI_PORT>/?ip=<HOST_IP>
```

## Ports

| Service | Port(s) | Protocol |
|---|---|---|
| SlimeVR Trackers | 6969 | UDP |
| Web GUI | `WEBGUI_PORT` | TCP |
| WebSocket Bridge | 21110 | TCP |
| OSC Router | 9000, 9002 | TCP/UDP |
| VRC OSC | 9000, 9001 | TCP/UDP |
| VMC | 39539, 39540 | TCP/UDP |
| Legacy Discovery | 4768 | UDP |

## Volumes

- `slimevr-config`: persistent SlimeVR config (`vrconfig.yml`)
- `slimevr-gui`: GUI static assets shared between app and Nginx

## Troubleshooting

- `ERR_TOO_MANY_REDIRECTS`: ensure redirect is only applied when `?ip=` is missing.
- Nginx error `server directive is not allowed here`: do not replace `nginx.conf` with a `server {}` block; use `conf.d/default.conf`.
- Linux USB not detected: run with `docker-compose.linux.yml` (hotplug mode).
- macOS/Windows USB passthrough: Docker Desktop does not expose raw USB devices to Linux containers like native Linux does. For direct USB trackers, use Linux (native/VM/WSL2 with USB/IP).
- Port already in use (`6969` or `21110`): stop conflicting processes or containers.

Check conflicts:

```bash
sudo ss -ltnup | grep -E '(:6969|:21110)'
```

## Update

To update SlimeVR, set a new `SLIMEVR_VERSION` in `.env` and recreate:

```bash
docker compose up -d --build
```

For Linux hotplug mode:

```bash
docker compose -f docker-compose.yml -f docker-compose.linux.yml up -d --build
```

## Credits

- [SlimeVR](https://slimevr.dev/)
- Web GUI assets from the official [SlimeVR releases](https://github.com/SlimeVR/SlimeVR-Server/releases)

## License

MIT

## Donations

BTC: `bc1qrd3mexqu43qn0597d248725kdp3tr28252q64p`

<!-- AUTO-UPDATE-DATE -->
**Last updated:** 2026-04-02
