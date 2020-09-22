# vagrant-boxmaker
makes vagrant boxes for vagrant cloud


## Box packaging
```
./build_box.sh
```
Then upload to  
https://app.vagrantup.com/greyltc/boxes  
https://app.vagrantup.com/arkmetrica/boxes

### Get and install public vagrant ssh key
Prior to packaging, you must replace the private re-generated ssh key with the public one or else vagrant won't be able to ssh into the box after distribution.  
This is now taken care of by ansible, but I'll leave this here anyway in case it needs to be done manually
```
curl -fsSL -o /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub
```
