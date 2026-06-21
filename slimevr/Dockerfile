# syntax=docker/dockerfile:1.4
# SlimeVR still needs privileged mode for USB/HID device passthrough,
# but the application process should run as a non-root user.
FROM eclipse-temurin:21-jre

ARG SLIMEVR_VERSION=latest
ENV SLIMEVR_VERSION=${SLIMEVR_VERSION}
ENV SLIMEVR_USER=ubuntu
ENV SLIMEVR_HOME=/home/ubuntu
ENV XDG_CONFIG_HOME=/home/ubuntu/.config
ENV HOME=/home/ubuntu

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl libusb-1.0-0 udev && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /gui /gui_mount "${XDG_CONFIG_HOME}/dev.slimevr.SlimeVR"

RUN if [ "${SLIMEVR_VERSION}" = "latest" ] || [ -z "${SLIMEVR_VERSION}" ]; then \
        echo "Fetching latest SlimeVR version..." && \
        SLIMEVR_VERSION=$(curl -sL https://api.github.com/repos/SlimeVR/SlimeVR-Server/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^v//') && \
        echo "Latest version: ${SLIMEVR_VERSION}"; \
    fi && \
    curl -L -o slimevr.jar https://github.com/SlimeVR/SlimeVR-Server/releases/download/v${SLIMEVR_VERSION}/slimevr.jar && \
    curl -L -o slimevr-gui-dist.tar.gz https://github.com/SlimeVR/SlimeVR-Server/releases/download/v${SLIMEVR_VERSION}/slimevr-gui-dist.tar.gz && \
    mkdir -p /gui && \
    tar -xzf slimevr-gui-dist.tar.gz -C /gui && \
    rm slimevr-gui-dist.tar.gz

RUN chown -R "${SLIMEVR_USER}:${SLIMEVR_USER}" /app /gui /gui_mount "${SLIMEVR_HOME}"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# ENTRYPOINT runs as root to fix device permissions, then drops to ubuntu via runuser
ENTRYPOINT ["/entrypoint.sh"]
CMD ["sh", "-c", "exec java -XX:ActiveProcessorCount=$(nproc) -jar slimevr.jar run --no-gui"]
