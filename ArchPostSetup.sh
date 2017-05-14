#!/bin/sh

hostnamectl set-hostname arch-1

echo "#################################################################"
echo "Configuring timezone"

echo "Enter your timezone in the format timezone/subzone:"
read zone
timedatectl set-timezone $zone

sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" /etc/locale.gen
sed -i "s/#en_US ISO-8859-1/en_US ISO-8859-1/g" /etc/locale.gen
locale-gen
localectl set-locale LANG="en_US.UTF-8"

echo "#################################################################"
echo "Configuring DHCP"

ip link

echo
echo "What is the name of your network interface (above)?:"

read interface

systemctl enable dhcpcd@$interface.service
systemctl start dhcpcd@$interface.service

echo "#################################################################"
echo "Enabling SSH"

pacman -Sy openssh net-tools --noconfirm
systemctl enable sshd.service
sed -i "s/#PermitRootLogin prohibit-password/#PermitRootLogin prohibit-password\nPermitRootLogin yes" /etc/ssh/sshd_config
systemctl start sshd.service

echo "#################################################################"
echo "Installing Apacman"
pacman -Sy --needed --asdeps jshon --noconfirm
curl -O "https://raw.githubusercontent.com/oshazard/apacman/master/apacman"
bash ./apacman -S apacman --noconfirm
rm apacman
apacman -S apacman-deps --noconfirm

echo "#################################################################"
echo "Installing Utilities"
pacman -Sy git bspwm sxhkd wget rxvt-unicode vim rofi dunst compton zsh feh mpd termite autocutsel dash neovim vim-airline --noconfirm
apacman -S polybar vimperator --noconfirm # note: firefox may block vimperator as an unverified addon
pacman -R vi --noconfirm
apacman -S vi-vim-symlink --noconfirm

echo "#################################################################"
echo "Installing X11"
pacman -S xorg-server xorg-xinit xorg-apps libinput --noconfirm

echo "#################################################################"
echo "Installing Dots"
git clone --recursive https://github.com/lordmilko/dots
shopt -s dotglob
rm -rf ~/.gnupg
mv ~/dots/* ~/
rm -rf ~/dots

echo "#################################################################"
echo "Installing Fonts"
mkdir -p ~/.fonts
pacman -S ttf-fira-mono --noconfirm
apacman -S ttf-unifont ttf-font-awesome tamzen-font-git envypn-font ttf-material-icons --noconfirm #do we maybe want the bdf unifont one?
git clone https://github.com/stark/siji ~/.fonts/siji
wget https://raw.githubusercontent.com/googlei18n/noto-fonts/master/hinted/NotoSans-Regular.ttf -P ~/.fonts/ # ttf-noto on AUR is over 400mb, and requires a very large /tmp
wget http://internode.dl.sourceforge.net/project/termsyn/termsyn-1.8.7.tar.gz
tar xvf termsyn-1.8.7.tar.gz
mkdir ~/.fonts/termsyn
mv termsyn-1.8.7/*.pcf ~/.fonts/termsyn/
rm -rf termsyn-1.8.7*
mkfontdir ~/.fonts/termsyn/

chmod +x ~/.local/bin/packages/themer/theme-activate