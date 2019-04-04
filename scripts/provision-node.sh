#!/usr/bin/env bash

# author: Danny Bastos <https://github.com/dannybastos>
# description: Setup a node(worker) for kubernetes
# version: 1.0
# license: MIT License

echo "swap disabled ..."
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo "================================"
echo "installing docker..."
echo "================================"
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2 wget git

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum install -y docker-ce-selinux-17.03.3.ce-1.el7 containerd.io
systemctl enable docker.service
systemctl start docker.service

#groupadd docker
usermod -aG docker vagrant #$USER

#docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "================================"
echo "install kubelet kubeadm kubectl..."
echo "================================"
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable --now kubelet

cat <<EOF >/etc/default/kubelet
KUBELET_EXTRA_ARGS=--cgroup-driver=systemd
EOF

mkdir -p /etc/docker
cat <<EOF >/etc/docker/daemon.json
{
  "insecure-registries": ["192.168.10.15:5000"],
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc # add autocomplete permanently to your bash shell.

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
lsmod | grep br_netfilter

echo "================================"
echo "restarting kubelet..."
echo "================================"
systemctl daemon-reload
systemctl restart kubelet
systemctl restart docker

echo "================================"
echo "node done!"
echo "================================"
