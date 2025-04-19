FROM eclipse-temurin:17-jdk

ARG SLIMEVR_VERSION
ENV SLIMEVR_VERSION=${SLIMEVR_VERSION}

WORKDIR /app

# Descarga jar y GUI según la versión
RUN curl -L -o slimevr.jar https://github.com/SlimeVR/SlimeVR-Server/releases/download/v${SLIMEVR_VERSION}/slimevr.jar && \
    curl -L -o slimevr-gui-dist.tar.gz https://github.com/SlimeVR/SlimeVR-Server/releases/download/v${SLIMEVR_VERSION}/slimevr-gui-dist.tar.gz && \
    mkdir /gui && \
    tar -xzf slimevr-gui-dist.tar.gz -C /gui && \
    rm slimevr-gui-dist.tar.gz

# Copia GUI al volumen compartido y lanza SlimeVR
CMD cp -r /gui/* /gui_mount && java -jar slimevr.jar run
