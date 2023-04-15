#!/bin/bash

set -e

SERVER_DIR=/opt/terraria

server="${SERVER_DIR}/LaunchUtils/ScriptCaller.sh -server -steamworkshopfolder ${SERVER_DIR}/workshop-mods/steamapps/workshop"
server="$server ${GAME_PARAMS}"

pipe=/tmp/tmodloader.pipe

echo -e "$server"

mkfifo $pipe
tmux new-session -s terraria -d "$server | tee $pipe"

# start interactive shell
/opt/scripts/start-gotty.sh 2>/dev/null &

cat $pipe &
wait ${!}
