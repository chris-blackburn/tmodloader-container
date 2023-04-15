FROM docker.io/steamcmd/steamcmd:alpine-3

# Install prerequisites
RUN apk update \
    && apk add --no-cache bash curl tmux libstdc++ libgcc icu-libs \
    && rm -rf /var/cache/apk/*

# Fix 32 and 64 bit library conflicts
RUN mkdir /steamlib \
    && mv /lib/libstdc++.so.6 /steamlib \
    && mv /lib/libgcc_s.so.1 /steamlib \
    && ulimit -n 2048
ENV LD_LIBRARY_PATH /steamlib

# create server user
ARG UID
ARG GID
RUN addgroup -g $GID terraria \
    && adduser terraria -u $UID -G terraria -h /opt/terraria -D
USER terraria
ENV USER terraria
ENV HOME /opt/terraria
WORKDIR $HOME

# Update SteamCMD and verify latest version
RUN steamcmd +quit

RUN curl -O https://raw.githubusercontent.com/tModLoader/tModLoader/1.4/patches/tModLoader/Terraria/release_extras/DedicatedServerUtils/manage-tModLoaderServer.sh \
    && chmod u+x manage-tModLoaderServer.sh \
    && ./manage-tModLoaderServer.sh -i -g --no-mods \
    && chmod u+x /opt/terraria/tModLoader/start-tModLoaderServer.sh

COPY scripts /opt/terraria
EXPOSE 7777

ENTRYPOINT ["/opt/terraria/start.sh"]
