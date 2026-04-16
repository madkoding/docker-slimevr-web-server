# syntax=docker/dockerfile:1.4
# Running as root is required because:
# - SlimeVR needs privileged mode for USB/HID tracker access
# - Java process needs access to /dev nodes
# - Docker container isolation provides the security boundary
FROM eclipse-temurin:21-jre

ARG SLIMEVR_VERSION=latest
ENV SLIMEVR_VERSION=${SLIMEVR_VERSION}

WORKDIR /app

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends curl libusb-1.0-0 udev && \
    apt-get clean

RUN if [ "${SLIMEVR_VERSION}" = "latest" ] || [ -z "${SLIMEVR_VERSION}" ]; then \
        echo "Fetching latest SlimeVR version..." && \
        SLIMEVR_VERSION=$(curl -sL https://api.github.com/repos/SlimeVR/SlimeVR-Server/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^v//') && \
        echo "Latest version: ${SLIMEVR_VERSION}"; \
    fi && \
    curl -L -o slimevr.jar https://github.com/SlimeVR/SlimeVR-Server/releases/download/v${SLIMEVR_VERSION}/slimevr.jar && \
    curl -L -o slimevr-gui-dist.tar.gz https://github.com/SlimeVR/SlimeVR-Server/releases/download/v${SLIMEVR_VERSION}/slimevr-gui-dist.tar.gz && \
    mkdir /gui && \
    tar -xzf slimevr-gui-dist.tar.gz -C /gui && \
    rm slimevr-gui-dist.tar.gz

VOLUME ["/gui_mount"]

CMD ["sh", "-c", "cp -r /gui/* /gui_mount && exec java -XX:ActiveProcessorCount=$(nproc) -jar slimevr.jar run --no-gui"]