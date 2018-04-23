# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/xenial64"
  config.vm.define "xtcommerce-5"
  config.vm.provider :virtualbox do |vb|
      vb.name = "xtcommerce-5"
  end

  config.ssh.forward_agent = true
  config.vm.provision :shell, path: "./bootstrap.sh"

  config.vm.network :forwarded_port, guest: 80, host: 8000
  config.vm.network :forwarded_port, guest: 3306, host: 33060

  config.vm.network "private_network", ip: "192.168.10.10"
  config.vm.synced_folder "../xtcommerce", "/var/www/html/xtcommerce"
  config.vm.synced_folder ".", "/vagrant"

  config.vm.provision "shell", :run => 'always', inline: <<-SHELL
    echo -e "\n--- Activate MySQL ---\n"
    sudo /etc/init.d/mysql start
  SHELL

end