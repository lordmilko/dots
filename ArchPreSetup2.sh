#!/bin/sh

echo "#################################################################"
echo "Blacklisting drivers"
arch-chroot /mnt
echo "blacklist intel_rapl" >> /etc/modprobe.d/blacklist.conf

echo "#################################################################"
echo "Configuring bootloader"
mkinitcpio -p linux
syslinux-install_update -iam
sed -i "s/TIMEOUT 50/TIMEOUT 3/g" /boot/syslinux/syslinux.cfg
sed -i "s/APPEND root=\/dev\/sda3/APPEND root=\/dev\/sda2/g" /boot/syslinux/syslinux.cfg

echo "#################################################################"
echo "Please enter a password"
passwd

