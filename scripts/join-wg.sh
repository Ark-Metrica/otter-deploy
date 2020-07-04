#!/usr/bin/env bash

if test $EUID -ne 0
then
  echo "Please run with root permissions"
  exit 1
fi

pacman -S --needed --noconfirm python wireguard-tools curl
curl -fsSL -o /bin/wg-request https://raw.githubusercontent.com/greyltc/wg-request/master/wg-request
chmod +x /bin/wg-request

wg genkey | tee /tmp/peer_A.key | wg pubkey > /tmp/peer_A.pub
timeout 5 python /bin/wg-request --port 48872 --private-key $(cat /tmp/peer_A.key) $(cat /tmp/peer_A.pub) pipe.0x3.ca > /etc/wireguard/wg0.conf 2>/dev/null
wg-quick up wg0
systemctl enable wg-quick@wg0

rm /tmp/peer_A.key
rm /tmp/peer_A.pub
rm -rf /tmp/wgr
