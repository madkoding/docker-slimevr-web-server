FROM eclipse-temurin:17-jdk

ARG SLIMEVR_VERSION=latest
ENV SLIMEVR_VERSION=${SLIMEVR_VERSION}

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl libusb-1.0-0 udev && \
    if [ "${SLIMEVR_VERSION}" = "latest" ] || [ -z "${SLIMEVR_VERSION}" ]; then \
        echo "Fetching latest SlimeVR version..." && \
        SLIMEVR_VERSION=$(curl -sL https://api.github.com/repos/SlimeVR/SlimeVR-Server/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^v//') && \
        echo "Latest version: ${SLIMEVR_VERSION}"; \
    fi && \
    curl -L -o slimevr.jar https://github.com/SlimeVR/SlimeVR-Server/releases/download/v${SLIMEVR_VERSION}/slimevr.jar && \
    curl -L -o slimevr-gui-dist.tar.gz https://github.com/SlimeVR/SlimeVR-Server/releases/download/v${SLIMEVR_VERSION}/slimevr-gui-dist.tar.gz && \
    mkdir /gui && \
    tar -xzf slimevr-gui-dist.tar.gz -C /gui && \
    rm slimevr-gui-dist.tar.gz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME ["/gui_mount"]

CMD cp -r /gui/* /gui_mount && java -XX:ActiveProcessorCount=$(nproc) -jar slimevr.jar run --no-gui