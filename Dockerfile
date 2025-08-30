FROM mcr.microsoft.com/dotnet/runtime:6.0 AS runtime

ARG TSHOCK_VERSION=5.2.4
ARG TERRARIA_VERSION=1.4.4.9
WORKDIR /tshock

RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip tar ca-certificates curl tzdata bash \
 && rm -rf /var/lib/apt/lists/*

RUN curl -L "https://github.com/Pryaxis/TShock/releases/download/v${TSHOCK_VERSION}/TShock-${TSHOCK_VERSION}-for-Terraria-${TERRARIA_VERSION}-linux-amd64-Release.zip" \
    -o tshock.zip \
 && unzip tshock.zip -d /tshock \
 && tar -xvf /tshock/TShock-Beta-linux-x64-Release.tar -C /tshock \
 && rm /tshock/TShock-Beta-linux-x64-Release.tar \
 && rm tshock.zip

RUN useradd -m -d /data -s /usr/sbin/nologin tshock \
 && mkdir -p /data/worlds /data/config /data/logs /data/plugins \
 && chown -R tshock:tshock /data /tshock

ENV PORT=7777
ENV MAX_PLAYERS=8
ENV WORLD_NAME=HoneyWorld
ENV AUTOCREATE=2
ENV SEED=

COPY --chown=tshock:tshock entrypoint.sh /tshock/entrypoint.sh
COPY worlds/HoneyWorld.wld /tshock/worlds/HoneyWorld.wld
RUN chmod +x /tshock/entrypoint.sh

EXPOSE 7777
WORKDIR /tshock

ENTRYPOINT ["/tshock/entrypoint.sh"]
