FROM eclipse-temurin:17-jdk

ARG SLIMEVR_VERSION
ARG CUSTOM_ZIP_URL=https://github.com/jabberrock/SlimeVR-Server/releases/download/stay-aligned-v7.3/stay-aligned-v7.3.zip
ENV SLIMEVR_VERSION=${SLIMEVR_VERSION} \
    CUSTOM_ZIP_URL=${CUSTOM_ZIP_URL}

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl unzip && \
    curl -fsSL -o slimevr-gui-dist.tar.gz https://github.com/SlimeVR/SlimeVR-Server/releases/download/v${SLIMEVR_VERSION}/slimevr-gui-dist.tar.gz && \
    curl -fsSL -o custom.zip ${CUSTOM_ZIP_URL} && \
    mkdir /gui && \
    tar -xzf slimevr-gui-dist.tar.gz -C /gui && \
    unzip -j custom.zip '*/slimevr.jar' -d /app && \
    rm slimevr-gui-dist.tar.gz custom.zip && \
    apt-get purge -y --auto-remove unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 2115 6969

VOLUME ["/gui_mount"]

CMD cp -r /gui/* /gui_mount && java -jar /app/slimevr.jar run
