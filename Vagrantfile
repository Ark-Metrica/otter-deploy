# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.
  config.vm.hostname =  "measurebox"

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "archlinux/archlinux"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  #config.vm.network "public_network", auto_config: false
  config.vm.network "public_network", auto_config: false, bridge: "eno1" # for bridge interface auto-select

  # need env var export VAGRANT_EXPERIMENTAL="disks"
  # for this:
  config.vm.disk :disk, size: "10GB", primary: true
  # doesn't resize the partition

  # need vagrant plugin install vagrant-disksize
  # for this one
  #config.disksize.size = '50GB'
  

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # disable the default
  config.vm.synced_folder ".", "/vagrant", disabled: true
  
  # make a new one with group writes enabled
  config.vm.synced_folder ".", "/portal", mount_options: ["umask=002"], automount: true
  
  # this should exist by default and might not be needed
  #config.vm.synced_folder "./", "/vagrant", owner: 'vagrant', group: 'vagrant', mount_options: ['dmode=775,fmode=664'], automount: true
  
  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    vb.name = "measurebox_dev"
    # Display the VirtualBox GUI when booting the machine
    #vb.gui = true
    vb.customize ["modifyvm", :id, "--vram", "128"]
    #vb.customize ["modifyvm", :id, "--graphicscontroller", "vboxvga"]
    vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]  # should give best performance
    vb.customize ["modifyvm", :id, "--accelerate3d", "off"]
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    # Customize the amount of memory on the VM:
    vb.memory = "8192"
    #vb.memory = "6144"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.
  
  # need VAGRANT_EXPERIMENTAL="typed_triggers" for this stuff and I still can't get it to work
  #config.trigger.after :provision do |trigger|
  #config.trigger.after :"Vagrant::Action::Builtin::Provision", type: :action do |t|
  #  t.info = "Setup done!"
  #  t.run = {inline: "vagrant reload"}
  #end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", path: "scripts/provision1.sh"  # phase 1
  config.vm.provision "ansible_local" do |ansible|  # phase 2
    ansible.limit = "*"
    ansible.playbook = "local.yml"
    ansible.provisioning_path = "/vagrant/ansible"
    ansible.inventory_path = "inventory"
    ansible.playbook_command = "ansible-pull"
    ansible.raw_arguments = ['-U', 'https://github.com/greyltc/ansible-playbooks', '-C', 'otter']
    ansible.tags = ['provision', 'make_admin', 'make_user', 'software', 'cleanup']
    #ansible.verbose = true
  end
end
