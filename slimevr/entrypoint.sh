#!/bin/sh
set -eu

# Fix /dev/hidraw* permissions (default 600 root:root) so the non-root
# Java process can open the HID interface for tracker communication.
fix_hidraw() {
    for dev in /dev/hidraw*; do
        if [ -e "$dev" ]; then
            chmod 660 "$dev" 2>/dev/null || true
            chgrp dialout "$dev" 2>/dev/null || true
        fi
    done
}

# Fix existing devices at startup
fix_hidraw

# Background watcher:
#   1. Fixes permissions on new hidraw devices (hotplug).
#   2. Detects USB disconnect/reconnect and restarts Java cleanly.
#      SlimeVR's HID manager throws NullPointerException after device
#      hotplug, so the only reliable fix is to restart the process.
(
    known_ids=""
    had_initial_connection=false
    was_disconnected=false

    while true; do
        fix_hidraw

        # Collect current device IDs (major:minor) to detect changes
        current_ids=""
        has_devices=false
        for dev in /dev/hidraw*; do
            if [ -e "$dev" ]; then
                has_devices=true
                id=$(stat -c "%t:%T" "$dev" 2>/dev/null)
                current_ids="$current_ids $id"
            fi
        done

        if $has_devices; then
            if ! $had_initial_connection; then
                had_initial_connection=true
            elif $was_disconnected || { [ -n "$known_ids" ] && [ "$current_ids" != "$known_ids" ]; }; then
                # Hotplug detected: device was removed and re-attached.
                # Kill Java to trigger a clean container restart via Docker.
                pkill -f "slimevr.jar" 2>/dev/null || true
            fi
            known_ids=$current_ids
            was_disconnected=false
        else
            if $had_initial_connection; then
                was_disconnected=true
            fi
        fi

        sleep 2
    done
) &

# Copy GUI to shared volume
cp -r /gui/. /gui_mount/

# Drop privileges to the slimevr user and exec CMD
exec runuser -u ubuntu -- "$@"
