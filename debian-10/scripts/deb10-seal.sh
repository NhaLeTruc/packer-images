#!/bin/bash -eux
apt-get autoremove -y
apt-get update
> /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id
