#!/usr/bin/env bash

sudo auditctl -e 0
sudo service auditd stop

sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask firewalld

sudo sed -i -e 's/installonly_limit=3/installonly_limit=2/g' /etc/yum.conf

sudo dnf -y update

sudo dnf -y install \
  vim \
  git \
  tar \
  bzip2 \
  wget \
  lsof \
  tree \
  rsync \
  strace \
  telnet \
  mlocate \
  net-tools \
  nfs-utils \
  dnf-utils \
  logrotate \
  traceroute \
  bind-utils \
  util-linux-user \
  openssh-clients \
  bash-completion \
  selinux-policy-devel \
  cloud-utils-growpart \
  elfutils-libelf-devel \
  ca-certificates

sudo mkdir -p /root/.ssh /home/packer/.ssh
sudo chmod 700 /root/.ssh /home/packer/.ssh
sudo chown -R packer:packer /home/packer/.ssh

if [[ -n $DEFAULT_SSH_KEY ]]; then
  sudo echo $DEFAULT_SSH_KEY | sudo tee /root/.ssh/authorized_keys > /dev/null 2>&1
  echo $DEFAULT_SSH_KEY > /home/packer/.ssh/authorized_keys
  sudo chmod 600 /root/.ssh/authorized_keys
  chmod 600 /home/packer/.ssh/authorized_keys
fi

echo 'Rebooting'
sudo reboot
