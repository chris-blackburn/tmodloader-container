#!/bin/bash

/opt/scripts/start-server.sh &
killpid="$!"

function shutdown() {
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
