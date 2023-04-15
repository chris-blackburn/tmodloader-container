FROM docker.io/steamcmd/steamcmd:ubuntu-22

# Install prerequisites
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        lib32stdc++6 lib32gcc-s1 lib32z1 libicu-dev \
        bash curl unzip tmux \
    && rm -rf /var/lib/apt/lists/*

# create server user
RUN useradd -m -d /opt/terraria -s /bin/bash terraria \
    && ulimit -n 2048
ENV USER=terraria
ENV HOME=/opt/terraria
ENV SERVER_SHUTDOWN_MESSAGE="Server shutting down!"
WORKDIR $HOME

# Update SteamCMD and verify latest version
RUN steamcmd +quit

RUN curl -O https://raw.githubusercontent.com/tModLoader/tModLoader/1.4/patches/tModLoader/Terraria/release_extras/DedicatedServerUtils/manage-tModLoaderServer.sh \
    && chmod +x manage-tModLoaderServer.sh \
    && ./manage-tModLoaderServer.sh -i -g --no-mods \
    && chmod +x /opt/terraria/tModLoader/start-tModLoaderServer.sh \
    && chmod +x /opt/terraria/tModLoader/LaunchUtils/*.sh \
    && mkdir -p $HOME/.local/share/Terraria

COPY scripts /opt/terraria
EXPOSE 7777

ENTRYPOINT ["/opt/terraria/start.sh"]
