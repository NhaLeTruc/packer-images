#!/usr/bin/env bash

sudo auditctl -e 0
sudo service auditd stop

sudo dnf -y remove --oldinstallonly --setopt installonly_limit=2 kernel

sudo dnf clean all
sudo rm -f /var/lib/dnf/history*
sudo rm -rf /var/cache/dnf

sudo logrotate -f /etc/logrotate.conf

sudo rm -f /var/log/*-???????? /var/log/*.gz
sudo rm -rf /var/log/anaconda
sudo bash -c 'cat /dev/null > /var/log/audit/audit.log'
sudo bash -c 'cat /dev/null > /var/log/wtmp'
sudo bash -c 'cat /dev/null > /var/log/lastlog'
sudo bash -c 'cat /dev/null > /var/log/dnf.log'
sudo bash -c 'cat /dev/null > /var/log/dnf.rpm.log'
sudo bash -c 'cat /dev/null > /var/log/dnf.librepo.log'
sudo bash -c 'cat /dev/null > /var/log/firewalld'

# Zero out the free space to save space in the final image:
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY

sudo sed -i '/UUID/d' /etc/sysconfig/network-scripts/ifcfg-enp0s3

sudo rm -f /etc/ssh/*key*

sudo rm -f /var/lib/NetworkManager/*
sudo rm -rf /tmp/*

sudo rm -f ~root/.vbox_version ~root/*-ks.cfg

history -cw

# Zero out the free space to save space in the final image:
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
