#!/usr/bin/env bash
systemctl is-active rsyslog && systemctl stop rsyslog

logrotate -f /etc/logrotate.conf

rm -f /var/log/*.1 /var/log/apt/*.1.gz

export DEBIAN_FRONTEND=noninteractive

apt-get autoremove -y
apt-get autoclean
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

history -cw
