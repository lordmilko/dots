#!/bin/sh

hostnamectl set-hostname arch-1

echo "#################################################################"
echo "Configuring timezone"

echo "Enter your timezone/subzone:"
read zone
timedatectl set-timezone $zone

sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" /etc/locale.gen
sed -i "s/#en_US ISO-8859-1/en_US ISO-8859-1/g" /etc/locale.gen
locale-gen
localectl set-locale LANG="en_US.UTF-8"

echo "#################################################################"
echo "Configuring DHCP"

ip link

echo "What is the name of your network interface (above?):"

read interface

systemctl enable dhcpd@$interface.service
systemctl start dhcpd@$interface.service

echo "#################################################################"
echo "Enabling SSH"

pacman -Sy openssh net-tools
systemctl enable sshd.service
sed -i "s/#PermitRootLogin prohibit-password/#PermitRootLogin prohibit-password\nPermitRootLogin yes"
systemctl start sshd.service

echo "#################################################################"
echo "Installing Apacman"
pacman -Sy --needed --asdeps jshon
curl -O "https://raw.githubusercontent.com/oshazard/apacman/master/apacman"
bash ./apacman -S apacman --noconfirm
rm apacman
apacman -S apacman-deps --noconfirm