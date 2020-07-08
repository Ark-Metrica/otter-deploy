#!/usr/bin/env bash

if test $EUID -ne 0
then
  echo "Please run with root permissions"
  exit 1
fi

PORT=${1:-48872}

pacman -S --needed --noconfirm python wireguard-tools curl 2>&1 >/dev/null
curl -fsSL -o /bin/wg-request https://raw.githubusercontent.com/greyltc/wg-request/master/wg-request 2>&1 >/dev/null
chmod +x /bin/wg-request 2>&1 >/dev/null

wg genkey | tee /tmp/peer_A.key | wg pubkey > /tmp/peer_A.pub
timeout 5 python3 /bin/wg-request --port "${PORT}" --private-key $(cat /tmp/peer_A.key) $(cat /tmp/peer_A.pub) pipe.0x3.ca > /etc/wireguard/wg0.conf 2>/dev/null
wg-quick down wg0 2>&1 >/dev/null
wg-quick up wg0 2>&1 >/dev/null
systemctl enable wg-quick@wg0 2>&1 >/dev/null

rm /tmp/peer_A.key 2>&1 >/dev/null
rm /tmp/peer_A.pub 2>&1 >/dev/null
