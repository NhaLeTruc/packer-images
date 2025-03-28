#!/usr/bin/env bash
echo '%sudo	ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/nopasswd_sudo

export DEBIAN_FRONTEND=noninteractive

apt-get -y update
apt-get -y upgrade

apt-get -y install --no-install-recommends \
  apt-utils \
  apt-transport-https \
  software-properties-common \
  gnupg2 \
  curl \
  ca-certificates

apt-get -y install --no-install-recommends \
  jq \
  git \
  tar \
  zip \
  zsh \
  vim \
  bat \
  sudo \
  less \
  lsof \
  ncdu \
  tree \
  rsync \
  unzip \
  locate \
  gnupg2 \
  dialog \
  strace \
  procps \
  dirmngr \
  fd-find \
  ripgrep \
  lsb-release \
  openssh-client \
  libc6 \
  libstdc++6 \
  locales \
  tzdata

apt-get -y remove --purge wpasupplicant

updatedb

echo -e "en_US ISO-8859-1\nen_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=C.UTF-8" > /etc/default/locale

mkdir -p /root/.ssh /home/packer/.ssh

chmod 700 /root/.ssh /home/packer/.ssh

if [[ -n $DEFAULT_SSH_KEY ]]; then
  echo $DEFAULT_SSH_KEY > /root/.ssh/authorized_keys
  echo $DEFAULT_SSH_KEY > /home/packer/.ssh/authorized_keys
  chmod 600 /root/.ssh/authorized_keys
  chmod 600 /home/packer/.ssh/authorized_keys
fi

chown -R packer:packer /home/packer/.ssh

reboot
