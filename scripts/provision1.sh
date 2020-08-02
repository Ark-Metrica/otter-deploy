#!/usr/bin/env bash
sudo reflector --latest 200 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist
sudo bash -c "yes | pacman -Syyuu --needed wireguard-tools"
sudo sed -i 's|ChallengeResponseAuthentication no|ChallengeResponseAuthentication yes|g' /etc/ssh/sshd_config
sudo curl -fsSL -o /bin/join-wg https://raw.githubusercontent.com/greyltc/wg-request/master/join-wg.sh
sudo chmod +x /bin/join-wg
sudo cp /etc/systemd/network/eth0.network /etc/systemd/network/eth1.network
sudo sed -i 's|Name=eth0|Name=eth1|g' /etc/systemd/network/eth1.network
sudo systemctl restart sshd
sudo systemctl restart systemd-networkd
sudo systemctl disable netctl@eth1.service
sudo bash -c "yes | pacman -Syu --needed virtualbox-guest-utils git"
