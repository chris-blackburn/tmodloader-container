#!/bin/bash

SERVERDATA=/opt/terraria

# install calamity
steamcmd +force_install_dir ~/.local/share/Terraria/wsmods +login anonymous +workshop_download_item 1281930 2824688072 +quit

# Installing/updating mods
mkdir -p ~/.local/share/Terraria
$SERVERDATA/manage-tModLoaderServer.sh -u --mods-only --check-dir ~/.local/share/Terraria --folder ~/.local/share/Terraria/wsmods

# Symlink tML's local dotnet install so that it can persist through runs
mkdir -p ~/.local/share/Terraria/dotnet
ln -s $SERVERDATA/.local/share/Terraria/dotnet/ $SERVERDATA/tModLoader/dotnet

# Start server
$SERVERDATA/start-server.sh &
killpid="$!"

function shutdown() {
    tmux send-keys -t terraria "say Server poopy bed time" Enter
    tmux send-keys -t terraria "exit" Enter
    tmuxPid=$(pidof tmux)

    while [ -e /proc/$tmodPid ]; do
        sleep .5
    done

    exit 143;
}

trap 'shutdown' SIGTERM
while true
do
    wait $killpid
    exit 0;
done
