#!/usr/bin/env bash

MACHINE="measurebox_dev"

# provision
vagrant up

# dump ssh config
vagrant ssh-config > vagrant-ssh

# ask machine to shutdown with password login
sshpass -p vagrant ssh -F vagrant-ssh vagrant:@default 'sudo shutdown -P now' # shutdown with password login
rm vagrant-ssh

# wait for machine to shutdown
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
