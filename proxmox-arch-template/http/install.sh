#!/bin/bash
set -e

# Arch Linux automated installation script for Packer
# This script performs an unattended Arch Linux installation

echo "Starting Arch Linux installation..."

# Set root password
echo "root:packer" | chpasswd

# Partition the disk
echo "Partitioning disk..."
sgdisk -Z /dev/sda
sgdisk -n 1:0:+512M -t 1:ef00 /dev/sda  # EFI partition
sgdisk -n 2:0:+2G -t 2:8200 /dev/sda    # Swap partition
sgdisk -n 3:0:0 -t 3:8300 /dev/sda      # Root partition

# Format partitions
echo "Formatting partitions..."
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 -F /dev/sda3

# Mount filesystems
echo "Mounting filesystems..."
mount /dev/sda3 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
swapon /dev/sda2

# Install base system
echo "Installing base system..."
pacstrap /mnt base base-devel linux linux-firmware

# Generate fstab
echo "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot and configure system
echo "Configuring system..."
arch-chroot /mnt /bin/bash <<'CHROOT'

# Set timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc

# Set locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set hostname
echo "archlinux" > /etc/hostname

# Configure hosts file
cat > /etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   archlinux.localdomain archlinux
EOF

# Set root password
echo "root:packer" | chpasswd

# Install essential packages
pacman -Sy --noconfirm grub efibootmgr networkmanager openssh sudo qemu-guest-agent cloud-init

# Install bootloader
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Enable services
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable qemu-guest-agent
systemctl enable cloud-init
systemctl enable cloud-init-local
systemctl enable cloud-config
systemctl enable cloud-final

# Configure SSH to allow root login
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Create sudoers entry
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

CHROOT

# Unmount and reboot
echo "Installation complete. Cleaning up..."
umount -R /mnt
swapoff /dev/sda2

echo "Arch Linux installation finished successfully!"
reboot
