# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- AGENTS.md with project conventions for AI coding agents
- `slimevr/entrypoint.sh` — fixes `/dev/hidraw*` permissions at startup and drops privileges to `ubuntu`
- Background watcher in entrypoint: polls every 2s to fix permissions on hotplugged hidraw devices
- Hotplug detection: restarts Java process on USB disconnect/reconnect to avoid SlimeVR NullPointerException

### Changed

- `slimevr/Dockerfile`: replaced `USER ubuntu` + `CMD` with `ENTRYPOINT` + `CMD` pattern for permission fixing

### Fixed

- Tracker HID access failure: `/dev/hidraw*` now automatically set to `660 dialout` inside the container
- Graceful handling of USB detach/re-attach cycles (e.g. via Windows usbipd)

### Removed
