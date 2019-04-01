# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vm.define "master" do |master|
        master.vm.box = "centos/7"
        master.vm.hostname = "master"
        master.vm.network :private_network, ip: "192.168.10.15", mac: "5CA1AB1E0001"
        master.vm.network :forwarded_port, guest: 22, host: 2215, id: "ssh", auto_correct:true
        # master.vm.network :forwarded_port, guest: 8001, host: 8080, id: "master-admin", auto_correct:true
        # master.vm.network :forwarded_port, guest: 31462, host: 8081, id: "app01", auto_correct:true

        for i in 30000..32762
          master.vm.network :forwarded_port, guest: i, host: i
        end

        master.vm.box_check_update = false
        master.vm.provider "virtualbox" do |v|
            v.memory = 4096
            v.cpus = 2
            v.customize ["modifyvm", :id, "--audio", "none"]
        end
        master.vm.provision "shell", path: "scripts/provision-node.sh"
        master.vm.provision "shell", path: "scripts/provision-master.sh"
    end
    config.vm.define "worker1" do |worker1|
        worker1.vm.box = "centos/7"
        worker1.vm.hostname = "worker1"
        worker1.vm.network :private_network, ip: "192.168.10.16", mac: "5CA1AB1E0002"
        worker1.vm.network :forwarded_port, guest: 22, host: 2216, id: "ssh", auto_correct:true
        worker1.vm.box_check_update = false
        worker1.vm.provider "virtualbox" do |v|
            v.memory = 2048
            v.cpus = 1
            v.customize ["modifyvm", :id, "--audio", "none"]
        end
        worker1.vm.provision "shell", path: "scripts/provision-node.sh"
        worker1.vm.provision "shell", inline: "echo execute 'kubeadm token create --print-join-command' to join command"
    end
    config.vm.define "worker2" do |worker2|
        worker2.vm.box = "centos/7"
        worker2.vm.hostname = "worker2"
        worker2.vm.network :private_network, ip: "192.168.10.17", mac: "5CA1AB1E0003"
        worker2.vm.network :forwarded_port, guest: 22, host: 2217, id: "ssh", auto_correct:true
        worker2.vm.box_check_update = false
        worker2.vm.provider "virtualbox" do |v|
            v.memory = 2048
            v.cpus = 2
            v.customize ["modifyvm", :id, "--audio", "none"]
        end
        worker2.vm.provision "shell", path: "scripts/provision-node.sh"
        worker2.vm.provision "shell", inline: "echo execute 'kubeadm token create --print-join-command' to join command"
    end
end
