#!/bin/bash

set -e

server="/opt/terraria/tModLoader/start-tModLoaderServer.sh -nosteam -steamworkshopfolder /opt/terraria/.local/share/Terraria/wsmods/steamapps/workshop"
server="$server -config /opt/terraria/.local/share/Terraria/serverconfig.txt"

pipe=/tmp/tmodloader.pipe

echo -e "$server"

mkfifo $pipe
tmux new-session -s terraria -d "$server | tee $pipe"

# start interactive shell
/opt/scripts/start-gotty.sh 2>/dev/null &

cat $pipe &
wait ${!}
