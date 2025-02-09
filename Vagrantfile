# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "my-ubuntu-20.04"

  config.vm.hostname = "vagrant-minikube"

  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = 10240
    libvirt.cpus   = 5
    libvirt.nested = true
  end
  
  config.vm.synced_folder ".", "/home/vagrant/project", owner: "vagrant", group: "vagrant", type: "rsync"

  config.vm.provision "shell", path: "setup-general.sh"
end