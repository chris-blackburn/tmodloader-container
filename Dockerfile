FROM debian:latest

ARG TMOD_SERVER_DIR="/opt/terraria"
ARG SERVERDATA="/opt/serverdata"

ENV TMOD_VERSION="v2022.09.47.47"
ENV TMOD_AUTODOWNLOAD="2824688072"
ENV TMOD_ENABLEDMODS="2824688072"
ENV GAME_PARAMS="-config /config/serverconfig.txt"

EXPOSE 7777
EXPOSE 9019

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        libicu-dev lib32gcc-s1 lib32stdc++6 lib32z1 \
        tmux unzip curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -d ${TMOD_SERVER_DIR} -s /bin/bash terraria && \
    mkdir -p ${SERVERDATA}/Worlds && \
    ulimit -n 2048

# Steam stuff
RUN mkdir -p /opt/steam
WORKDIR /opt/steam
RUN curl -sqL http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar zxvf - && \
    chmod -R 755 /opt/steam
RUN ./steamcmd.sh +force_install_dir ${SERVERDATA}/workshop-mods +login anonymous +quit

WORKDIR ${TMOD_SERVER_DIR}

# Get the terraria stuff
RUN curl -sqL https://github.com/tModLoader/tModLoader/releases/download/${TMOD_VERSION}/tModLoader.zip -o tModLoader.zip
RUN unzip -o tModLoader.zip && rm tModLoader.zip

ADD /config/ /config/
ADD scripts /opt/scripts
RUN chown -R terraria:terraria /config /opt && \
    chmod -R 755 /config /opt

USER terraria

ENTRYPOINT ["/opt/scripts/start.sh"]
