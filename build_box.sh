#!/usr/bin/env bash
set -e

MACHINE="measurebox_dev"

# provision
vagrant up

# replace the ssh key and shut off the machine
vagrant ssh -c 'curl -fsSL -o /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub; chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys; chown -R vagrant:vagrant ~/.ssh; history -r; sudo shutdown -P now'

# dump ssh config
#vagrant ssh-config > vagrant-ssh

# replace the ssh key and shut off the machine
#sshpass -p vagrant ssh -F vagrant-ssh vagrant:@default 'curl -fsSL -o /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub;chmod 700 ~/.ssh;chmod 600 ~/.ssh/authorized_keys;chown -R vagrant:vagrant ~/.ssh'

# ask machine to shutdown with password login
#sshpass -p vagrant ssh -F vagrant-ssh vagrant:@default 'sudo shutdown -P now'
#rm vagrant-ssh

# wait for the shutdown to complete
until $(VBoxManage showvminfo --machinereadable ${MACHINE} | grep -q ^VMState=.poweroff.)
do
  sleep 1
done
sleep 1

# package the box
rm out.box
rm -rf vtmp
VAGRANT_HOME=./vtmp vagrant package --base ${MACHINE} --output ./out.box
rm -rf vtmp

# read its checksum
sha512sum out.box
