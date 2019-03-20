locale-gen pt_BR.UTF-8

echo "swap disabled ..."
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo "================================"
echo "install docker..."
echo "================================"
#curl -fsSL https://get.docker.com | bash

curl -fsSL https://apt.dockerproject.org/gpg | apt-key add -
apt-add-repository "deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -cs) main"
apt-get update
apt-cache policy docker-engine
apt-get install -y docker-engine

#groupadd docker
usermod -aG docker vagrant #$USER

#docker-compose
#curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#chmod +x /usr/local/bin/docker-compose

echo "================================"
echo "install kubelet kubeadm kubectl..."
echo "================================"
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

sed -i "s/\$KUBELET_EXTRA_ARGS/\$KUBELET_EXTRA_ARGS\ --cgroup-driver=systemd/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
cat <<EOF >/etc/docker/daemon.json
{
    "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc # add autocomplete permanently to your bash shell.

echo "================================"
echo "restarting kubelet..."
echo "================================"
systemctl daemon-reload
systemctl restart kubelet
systemctl restart docker

echo "================================"
echo "node done!"
echo "================================"
