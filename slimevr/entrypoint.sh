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

# Background watcher: polls for new hidraw devices (e.g. after USB
# detach/re-attach via Windows usbipd) and fixes permissions on the fly.
(
    while true; do
        fix_hidraw
        sleep 2
    done
) &

# Copy GUI to shared volume
cp -r /gui/. /gui_mount/

# Drop privileges to the slimevr user and exec CMD
exec runuser -u ubuntu -- "$@"
