#!/bin/sh
set -eu

# Fix hidraw permissions for SlimeVR tracker HID access.
# /dev/hidraw* defaults to 600 root:root on Linux, but the Java
# process runs as non-root (ubuntu). The container is privileged,
# so this entrypoint fixes the permissions at startup.
for dev in /dev/hidraw*; do
    if [ -e "$dev" ]; then
        chmod 660 "$dev"
        chgrp dialout "$dev"
    fi
done

# Copy GUI to shared volume
cp -r /gui/. /gui_mount/

# Drop privileges to the slimevr user and exec CMD
exec runuser -u ubuntu -- "$@"
