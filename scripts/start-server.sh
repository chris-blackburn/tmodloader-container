#!/bin/bash

set -e

server="/opt/terraria/tModLoader/LaunchUtils/ScriptCaller.sh -server"
server="$server -nosteam -steamworkshopfolder /opt/terraria/.local/share/Terraria/wsmods/steamapps/workshop"
server="$server -config /opt/terraria/.local/share/Terraria/serverconfig.txt"

pipe=/tmp/tmodloader.pipe

echo -e "$server"

mkfifo $pipe
tmux new-session -s terraria -d "$server | tee $pipe"

cat $pipe &
wait ${!}
