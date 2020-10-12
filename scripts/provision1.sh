#!/usr/bin/env bash

# fix up pacman
pacman-key --init
pacman-key --populate archlinux
sudo reflector --latest 200 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# stuff for having enough room to grow
#sudo bash -c "yes | pacman -S gptfdisk parted"

#sudo sgdisk --resize-table=2 /dev/sda
#sudo partprobe

#sudo sgdisk -N 0 -t 0:8300 /dev/sda
#sudo partprobe
#sudo btrfs device add /dev/sda3 /
#sudo btrfs filesystem balance /

sudo bash -c "yes | pacman -Syyuu --needed wireguard-tools"
sudo sed -i 's|ChallengeResponseAuthentication no|ChallengeResponseAuthentication yes|g' /etc/ssh/sshd_config

sudo curl -fsSL -o /bin/join-wg https://raw.githubusercontent.com/greyltc/wg-request/master/join-wg.sh
sudo chmod +x /bin/join-wg

sudo cp /vagrant/scripts/wg-helper /bin/.
sudo chmod +x /bin/wg-helper

sudo cp /vagrant/scripts/wg-helper.service /etc/systemd/system/.
sudo chmod 644 /etc/systemd/system/wg-helper.service
sudo systemctl enable wg-helper.service

# makes sure we're able to wait for the vagrant networking to start
sudo cp /vagrant/scripts/vwait /bin/.
sudo chmod +x /bin/vwait

sudo cp /vagrant/scripts/vwait.service /etc/systemd/system/.
sudo chmod 644 /etc/systemd/system/vwait.service
sudo systemctl enable vwait.service

# fix vagrant networking
sudo cp /etc/systemd/network/eth0.network /etc/systemd/network/eth1.network
sudo sed -i 's|Name=eth0|Name=eth1|g' /etc/systemd/network/eth1.network
sudo systemctl restart sshd
sudo systemctl restart systemd-networkd
sudo systemctl disable netctl@eth1.service

# get the proper vbox guest utils going
sudo bash -c "yes | pacman -Syu --needed virtualbox-guest-utils git"
sudo systemctl enable vboxservice.service
sudo systemctl start vboxservice.service
