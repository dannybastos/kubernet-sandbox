# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box_check_update = false
  config.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 2
      v.customize ["modifyvm", :id, "--audio", "none"]
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

    config.vm.define "master" do |master|
        master.vm.box = "centos/7"
        master.vm.hostname = "master"
        master.vm.network :private_network, ip: "192.168.10.15", mac: "5CA1AB1E0001"
        master.vm.network :forwarded_port, guest: 22, host: 2215, id: "ssh", auto_correct:true

        # for i in 30000..32762
        #   master.vm.network :forwarded_port, guest: i, host: i
        # end

        master.vm.provision "shell", path: "scripts/provision-node.sh"
        master.vm.provision "shell", path: "scripts/provision-master.sh"
    end
    config.vm.define "worker1" do |worker1|
        worker1.vm.box = "centos/7"
        worker1.vm.hostname = "worker1"
        worker1.vm.network :private_network, ip: "192.168.10.16", mac: "5CA1AB1E0002"
        worker1.vm.network :forwarded_port, guest: 22, host: 2216, id: "ssh", auto_correct:true
        worker1.vm.provision "shell", path: "scripts/provision-node.sh"
        worker1.vm.provision "shell", inline: "kubeadm join --token dannyb.supersecret10101 --discovery-token-unsafe-skip-ca-verification 192.168.10.15:6443"
    end
    config.vm.define "worker2" do |worker2|
        worker2.vm.box = "centos/7"
        worker2.vm.hostname = "worker2"
        worker2.vm.network :private_network, ip: "192.168.10.17", mac: "5CA1AB1E0003"
        worker2.vm.network :forwarded_port, guest: 22, host: 2217, id: "ssh", auto_correct:true
        worker2.vm.provision "shell", path: "scripts/provision-node.sh"
        worker2.vm.provision "shell", inline: "kubeadm join --token dannyb.supersecret10101 --discovery-token-unsafe-skip-ca-verification 192.168.10.15:6443"
    end
end
