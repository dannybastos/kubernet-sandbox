# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vm.define "k8s" do |k8s|
        k8s.vm.box = "centos/7"
        k8s.vm.hostname = "k8s"
        k8s.vm.network :private_network, ip: "192.168.10.15", mac: "5CA1AB1E0001"
        k8s.vm.network :forwarded_port, guest: 22, host: 2215, id: "ssh", auto_correct:true
        # k8s.vm.network :forwarded_port, guest: 8001, host: 8080, id: "k8s-admin", auto_correct:true
        # k8s.vm.network :forwarded_port, guest: 31462, host: 8081, id: "app01", auto_correct:true

        k8s.vm.box_check_update = false
        k8s.vm.provider "virtualbox" do |v|
            v.memory = 4096
            v.cpus = 2
            v.customize ["modifyvm", :id, "--audio", "none"]
        end
        k8s.vm.provision "shell", path: "scripts/provision-node.sh"
        k8s.vm.provision "shell", path: "scripts/provision-master.sh"
    end
    config.vm.define "node1" do |node1|
        node1.vm.box = "centos/7"
        node1.vm.hostname = "node1"
        node1.vm.network :private_network, ip: "192.168.10.16", mac: "5CA1AB1E0002"
        node1.vm.network :forwarded_port, guest: 22, host: 2216, id: "ssh", auto_correct:true
        node1.vm.box_check_update = false
        node1.vm.provider "virtualbox" do |v|
            v.memory = 2048
            v.cpus = 1
            v.customize ["modifyvm", :id, "--audio", "none"]
        end
        node1.vm.provision "shell", path: "scripts/provision-node.sh"
        node1.vm.provision "shell", inline: "echo execute 'kubeadm token create --print-join-command' to join command"
    end
    config.vm.define "node2" do |node2|
        node2.vm.box = "centos/7"
        node2.vm.hostname = "node2"
        node2.vm.network :private_network, ip: "192.168.10.17", mac: "5CA1AB1E0003"
        node2.vm.network :forwarded_port, guest: 22, host: 2217, id: "ssh", auto_correct:true
        node2.vm.box_check_update = false
        node2.vm.provider "virtualbox" do |v|
            v.memory = 2048
            v.cpus = 2
            v.customize ["modifyvm", :id, "--audio", "none"]
        end
        node2.vm.provision "shell", path: "scripts/provision-node.sh"
        node2.vm.provision "shell", inline: "echo execute 'kubeadm token create --print-join-command' to join command"
    end
end
