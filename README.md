# SlimeVR Docker

Run [SlimeVR Server](https://github.com/SlimeVR/SlimeVR-Server) + Web GUI in Docker.

## Quick Start

```bash
docker compose up -d --build
open http://localhost:8080
```

Stop:
```bash
docker compose down
```

## What it does

```mermaid
sequenceDiagram
    participant User
    participant Nginx
    participant SlimeVR
    participant Tracker

    Note over SlimeVR: Starts, downloads latest version<br/>from GitHub automatically
    SlimeVR->>Tracker: Detect trackers via USB/HID
    SlimeVR->>Nginx: Copy GUI to /gui_mount
    User->>Nginx: GET /:8080
    Nginx-->>User: 302 → /?ip=<host_ip>
    User->>Nginx: GET /?ip=<host_ip>
    Nginx->>User: Serve SlimeVR Web GUI
    User->>SlimeVR: WebSocket connections
    Tracker->>SlimeVR: Tracking data (port 6969)
```

## Architecture

| Container | Purpose | Network |
|-----------|---------|---------|
| `slimevr` | Java server + tracker comms | host |
| `nginx` | Serves Web GUI | host |

Healthchecks:
- `slimevr`: validates the Java process is running
- `nginx`: validates local HTTP response on `127.0.0.1:${WEBGUI_PORT}`

- **slimevr**: Downloads latest SlimeVR from GitHub, copies GUI to volume
- **nginx**: Serves GUI, auto-redirects with `?ip=` parameter for WebSocket connection

## Configuration

Create `.env` if you need custom values (all optional):

```env
WEBGUI_PORT=8080
SLIMEVR_VERSION=latest
# Optional: serial group id for /dev/ttyACM* access
# On Arch this is typically 984 (uucp)
SERIAL_GID=984
```

Without `.env`, defaults are used (port `8080`, latest version).

## Volumes

| Volume | Purpose |
|--------|---------|
| `slimevr-config` | Persists SlimeVR config in `/home/ubuntu/.config/dev.slimevr.SlimeVR` |
| `slimevr-gui` | GUI assets (slimevr → nginx) |

## Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 6969 | UDP | Tracker data |
| 8080 | TCP | Web GUI |
| 21110 | TCP | WebSocket VR Bridge |
| 9000-9002 | TCP/UDP | OSC |
| 39539-39540 | TCP/UDP | VMC |

## Update

```bash
docker compose up -d --build
```

Always downloads latest unless you set `SLIMEVR_VERSION` in `.env`.

## USB / Serial Device Access

SlimeVR needs access to USB serial devices (`/dev/ttyACM*`, `/dev/ttyUSB*`, `/dev/hidraw*`) to communicate with trackers.

### Linux (native)

The container runs as `ubuntu` (UID 1000) and is added to the `dialout` and `video` groups. Make sure your user owns or has access to the serial devices:

```bash
ls -l /dev/ttyACM0  # check device permissions
getent group dialout # check dialout GID
```

If your distro uses a different group for serial devices (e.g. Arch uses `uucp`), add the GID in `.env`:

```env
SERIAL_GID=984    # Arch: uucp
```

Then uncomment `SERIAL_GID` in `docker-compose.yml` under `group_add`.

### Windows (WSL2)

Docker Desktop on WSL2 does **not** expose USB devices by default. You need [usbipd-win](https://github.com/dorssel/usbipd-win) to attach USB devices to WSL2:

```powershell
# Windows (Admin PowerShell)
usbipd bind --busid <BUSID>
usbipd attach --wsl --busid <BUSID>
```

### Diagnostics

Run `./slimevrctl doctor` to check serial device visibility inside the container.

## Troubleshooting

### Error: `failed to add ... veth ... operation not supported`

If your Docker host/kernel does not support creating the default bridge/veth pair,
the one-shot `slimevr-init` container can fail before startup. This project sets
`network_mode: none` for that init container because it only prepares volumes and
does not need network access.

If you still hit this error, make sure your local `docker-compose.yml` includes:

```yaml
services:
  slimevr-init:
    network_mode: none
```

```bash
# Check status
docker compose ps

# View logs
docker compose logs -f

# Full diagnostics
./slimevrctl doctor
```

## Credits

- [SlimeVR](https://slimevr.dev/)
- GUI from official [SlimeVR releases](https://github.com/SlimeVR/SlimeVR-Server/releases)

## License

MIT
