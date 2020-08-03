#!/usr/bin/env bash

vagrant up
vagrant halt
rm out.box
rm -rf vtmp
VAGRANT_HOME=./vtmp vagrant package --base measurebox_dev --output ./out.box
sha512sum out.box
