#!/bin/bash

SERVERDATA=/opt/terraria

# Installing/updating mods
$SERVERDATA/manage-tModLoaderServer.sh -u --mods-only \
    --check-dir $SERVERDATA/.local/share/Terraria \
    --folder $SERVERDATA/.local/share/Terraria/wsmods

# Symlink tML's local dotnet install so that it can persist through runs
mkdir -p $SERVERDATA/.local/share/Terraria/dotnet
ln -s $SERVERDATA/.local/share/Terraria/dotnet/ $SERVERDATA/tModLoader/dotnet

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

# Start server
$SERVERDATA/start-server.sh &
killpid="$!"

while true
do
    wait $killpid
    exit 0;
done
