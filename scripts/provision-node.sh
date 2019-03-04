locale-gen pt_BR.UTF-8

echo "desabilitando swap..."
swapoff -a
echo "desabilitar inicializacao do swap no /etc/fstab..."
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo "================================"
echo "instalação do docker..."
echo "================================"
#curl -fsSL https://get.docker.com | bash

curl -fsSL https://apt.dockerproject.org/gpg | apt-key add -
apt-add-repository "deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -cs) main"
apt-get update
apt-cache policy docker-engine
apt-get install -y docker-engine

groupadd docker
usermod -aG docker vagrant #$USER

echo "================================"
echo "instalação do kubelet kubeadm kubectl..."
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

#sudo --user=vagrant source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc # add autocomplete permanently to your bash shell.

echo "================================"
echo "reiniciando kubelet..."
echo "================================"
systemctl daemon-reload
systemctl restart kubelet
systemctl restart docker

echo "================================"
echo "done!"
echo "================================"
