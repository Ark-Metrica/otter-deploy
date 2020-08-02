# vagrant-boxmaker
makes vagrant boxes for vagrant cloud


## Box packaging
Prior to packaging, you must replace the private re-generated ssh key with the public one or else vagrant won't be able to ssh into the box after distribution.
```
curl -fsSL -o /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub
```

```
VAGRANT_HOME=./vtmp vagrant package --base vagrant-boxmaker_default_1596385806730_16282 --output ./out.box
```
Then upload to https://app.vagrantup.com/greyltc/boxes
