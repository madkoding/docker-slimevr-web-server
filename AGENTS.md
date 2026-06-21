# Agents

Project-specific instructions for AI coding agents.

## Project Overview

Dockerized deployment of [SlimeVR Server](https://github.com/SlimeVR/SlimeVR-Server) + Web GUI. Runs a Java-based full-body tracking server behind nginx, orchestrated with Docker Compose.

## Tech Stack

- **Runtime:** Java 21 (eclipse-temurin:21-jre)
- **Web server:** nginx:alpine
- **Orchestration:** Docker Compose
- **CI/CD:** GitHub Actions (Docker Buildx, multi-arch)
- **Scripting:** bash

## Directory Structure

```
├── config/
│   └── vrconfig.yml            # Default SlimeVR configuration
├── nginx/
│   ├── Dockerfile               # nginx:alpine image
│   ├── entrypoint.sh            # Injects SLIMEVR_IP + WEBGUI_PORT via envsubst
│   └── templates/
│       └── default.conf.template
├── slimevr/
│   ├── Dockerfile               # eclipse-temurin:21-jre, downloads SlimeVR JAR + GUI
│   └── entrypoint.sh            # Fixes hidraw perms as root, drops to ubuntu, runs server
├── .env.example
├── docker-compose.yml
├── slimevrctl                   # Convenience management script
└── CHANGELOG.md                 # Keep a Changelog format
```

## Key Commands

| Command | Description |
|---|---|
| `./slimevrctl up` | Build and start containers in background |
| `./slimevrctl down` | Stop and remove containers |
| `./slimevrctl restart` | Restart (down + up) |
| `./slimevrctl logs` | Follow logs |
| `./slimevrctl status` | Show container status |
| `./slimevrctl doctor` | Run diagnostics (serial, groups, logs) |
| `docker compose up -d --build` | Build and start directly |
| `docker compose logs -f` | Follow logs directly |
| `docker compose ps` | Container status directly |

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `WEBGUI_PORT` | `8080` | Port for the web GUI |
| `SLIMEVR_VERSION` | `latest` | SlimeVR Server release version |
| `SERIAL_GID` | (not set) | Serial group GID for USB trackers (e.g., Arch uucp = 984) |

Copy `.env.example` to `.env` to customize.

## Coding Conventions

- **Shell scripts:** Use `#!/usr/bin/env bash` with `set -euo pipefail`.
- **Dockerfiles:** Use `apt-get` with `--no-install-recommends` and cleanup in the same `RUN` layer. Pin base image tags.
- **YAML:** 2-space indentation. Use `${VAR:-default}` for optional env vars.
- **Changelog:** Follow [Keep a Changelog](https://keepachangelog.com/) format in `CHANGELOG.md`.
- **Environment:** Document optional variables in `.env.example` (commented out).

## CI/CD

- File: `.github/workflows/docker-publish.yml`
- On push to `main` or `v*` tags.
- Builds multi-arch images (`linux/amd64`, `linux/arm64`).
- Pushes to Docker Hub under `madkoding/slimevr-server` and `madkoding/slimevr-web-server`.

## Ports

| Port | Protocol | Service |
|---|---|---|
| 6969 | TCP/UDP | Tracker data |
| 21110 | TCP | Web GUI WebSocket |
| 9000-9002 | TCP/UDP | OSC |
| 39539-39540 | TCP/UDP | VMC |

## Notes

- The `slimevr-init` service (busybox) prepares volume directories before the main server starts.
- The nginx entrypoint resolves the container's own IP via `eth0` and uses `envsubst` for template rendering.
- The SlimeVR server runs with `--no-gui` flag; the GUI is served separately by nginx.
- The nginx config auto-redirects requests to append `?ip=<host_ip>` for WebSocket connections.
- The slimevr entrypoint (`slimevr/entrypoint.sh`) runs as root to fix `/dev/hidraw*` permissions (changing mode to 660 and group to dialout), then drops privileges to the `ubuntu` user via `runuser` before executing the server.
