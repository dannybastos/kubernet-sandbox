#!/usr/bin/env bash

# author: Danny Bastos <https://github.com/dannybastos>
# description: Setup a master for kubernetes
# version: 1.0
# license: MIT License

echo "================================"
echo "starting kubernetes..."
echo "================================"
# ip of this box
IP_ADDR=`ip addr show eth1 | grep "inet " | awk '{print $2}' | cut -f1 -d/`
HOST_NAME=$(hostname -s)
echo "================================"
kubeadm init --apiserver-advertise-address=$IP_ADDR \
  --apiserver-cert-extra-sans=$IP_ADDR \
  --node-name=$HOST_NAME \
  --pod-network-cidr=192.168.0.0/16 \
  --token=dannyb.supersecret10101
echo "================================"

#copying credentials to regular user - vagrant
sudo --user=vagrant mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config

echo "================================"
echo "installing pod network (calico)..."
echo "================================"

#calico
export KUBECONFIG=/etc/kubernetes/admin.conf
sudo --user=vagrant kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
sudo --user=vagrant kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml

echo "================================"
echo "publish kubernetes dashboard ..."
echo "================================"
sudo --user=vagrant kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended/kubernetes-dashboard.yaml
sudo --user=vagrant kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

#create service-account
sudo --user=vagrant kubectl apply -f /vagrant/scripts/dashboard-admin-user.yaml
#create role cluster binding
sudo --user=vagrant kubectl apply -f /vagrant/scripts/dashboard-cluster-role-binding.yaml
#generate token
sudo --user=vagrant kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
