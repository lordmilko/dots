This repo is a fork of jaagr's dotfile/themer configuration, complete with necessary instructions to get it up and running in a VMware environment for testing purposes.

[Incomplete]

# Enhancements
* Creates gitignored directories (.cache, .wallpapers)
* Includes vim color schemes
* Includes necessary shell scripts/bugfixes
* Removes settings specific to jaagr's PC

# Rough Notes

1. TODO: how to install all necessary packages
2. rm -rf ~/* && rm -rf ~/.* # warning! this will delete everything in ~
3. git clone --recursive https://github.com/lordmilko/dots ~/
4. Install fonts
5. Run **wm_launcher**
6. win+enter
7. chmod +x ~/themer # file currently deleted, use ~/.local/bin/packages/themer/theme-activate
8. ~/themer space
9. Edit ~/.profile and up the top swap the export MONITOR1 variable based on your distro. If you want to set this to something else, under X do **xrandr** and observe the output name

# Packages

## Arch Linux

### Initial Setup

1. Download the latest Arch ISO, or use the [netboot installer](https://releng.archlinux.org/pxeboot/ipxe.iso)
2. Create a new VM with the following specs:

    * CPU: 2
    * RAM: 2GB
    * HDD: 30GB
    * OS: Linux/Other 3.x or Later (64-bit)

3. Boot the disk
4. If booted from the netboot ISO, run `ping google.com` to confirm DNS is working. If DNS is not working, run `echo "nameserver 8.8.8.8"` >> /etc/resolv.conf
5. Run `cfdisk /dev/sda` and configure your disk by selecting the following:

    Partition: dos, New, 512M, primary, bootable, down arrow, New, 27.5G, primary, down arrow, New, 2G, primary, Write, yes, Quit

6. Format the partitions

   ```sh
   mkswap /dev/sda3
   swapon /dev/sda3
   mkfs.ext4 /dev/sda1 -O \^64bit
   mkfs.ext4 /dev/sda2 -O \^64bit
   mount /dev/sda2 /mnt
   mkdir /mnt/boot
   mount /dev/sda1 /mnt/boot
   ```
7. Install Arch

   ```sh
   # Install base
   pacstrap /mnt base

   # Install bootloader
   pacstrap /mnt syslinux
   genfstab -p /mnt >> /mnt/etc/fstab

   # chroot into new system
   arch-chroot /mnt
   echo "blacklist intel_rapl" >> /etc/modprobe.d/blacklist.conf

   # Update boot config
   mkinitcpio -p linux
   syslinux-install_update -iam
   ```
8. Set root password
   ``` sh
   passwd
   ```
9. Update your syslinux config
   ``` sh
   vi /boot/syslinux/syslinux.cfg
   ```
    Change the **TIMEOUT** from 50 to 3 (line 23)

    Under **LABEL arch** and **LABEL archfallback** change the disk from /dev/sda3 to /dev/sda2 (lines 54+60)

    Restart
   ```sh
   umount /mnt/boot /mnt
   systemctl reboot
   ```

10. Setup finalization

   ```sh
   hostnamectl set-hostname arch-1
   timedatectl set-timezone **<zone>**/**subzone** # use *timedatectl list-timezones to determine this*
   vi /etc/locale.gen #find and uncomment the two en_US ones
   locale-gen
   localectl set-locale LANG="en_US.UTF-8"
   ```
   Check your hostname with `ip link` then enable dhcp, where `<interface>` is your network interface
   ```sh
   systemctl enable dhcpcd@<interface>.service
   systemctl start dhcpcd@<interface>.service
   ```
   Configure remote access
   ```sh
   pacman -Sy openssh net-tools
   systemctl enable sshd.service
   vi /etc/sshd_config
   ```

   Under "#PermitRootLogin prohibit-password" add `PermitRootLogin yes`, then run `systemctl start sshd.service`

   Check your IP Address with `ifconfig` then SSH into your system

#### Post Install Setup

Run the following commands

```sh
# apacman
pacman -S --needed --asdeps jshon
curl -O "https://raw.githubusercontent.com/oshazard/apacman/master/apacman"
bash ./apacman -S apacman --noconfirm
rm apacman
apacman -S apacman-deps --noconfirm

# utilities
pacman -S git bspwm sxhkd wget rxvt-unicode vim rofi dunst compton zsh feh mpd termite autocutsel dash neovim --noconfirm
apacman -S polybar
pacman -R vi --noconfirm
apacman -S vi-vim-symlink --noconfirm

# X11
pacman -S xorg-server xorg-xinit xorg-server-utils libinput --noconfirm

# dots
git clone --recursive https://github.com/lordmilko/dots
shopt -s dotglob
mv ~/dots/* ~/
rm -rf ~/dots

# Fonts
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
```
Edit ~/.profile and make sure the Arch Linux MONITOR1 variable is the only MONITOR1 variable uncommented

Launch WM and set your theme
```sh
chmod +x ~/.local/bin/packages/themer/theme-activate
~/.local/bin/packages/themer/theme-activate darkpx
```

## Void Linux

*termite is currently incompatible with Void Linux. urxvt can be opened once setup has completed via win+shift+enter*

1. Download the latest Void ISO ("void-live-x86_64-<date>.iso")
2. Create a new VM with the following specs:

    * CPU: 2
    * RAM: 2GB
    * HDD: 30GB
    * OS: Linux/Other 3.x or Later (64-bit)

3. Boot the disk
4. Login as root/voidlinux
5. Confirm you can ping google.com and that your VM's NIC is setup correctly
6. Run **void-installer** and enter the following details (if a section is not listed, don't modify the defaults)

    * Source: local
    * Hostname: void-1
    * User account: admin/admin/<some password>
    * Timezone: <your timezone>
    * RootPassword: <some password>
    * Bootloader: /dev/sda/ / use a graphical terminal
    * Partition: dos, New, 512M, Primary, bootable, down arrow, New, 27.5G, primary, down arrow, New, 2G, primary, Write, yes, Quit
    * Filesystems: /dev/sda1: ext4, /boot, yes; dev/sda2: ext4, /, yes; /dev/sda3: swap, yes, Back
    * Install

7. Install packages

``` sh
chsh --shell /bin/bash root
xbps-install -Sy net-tools
xbps-install -Syu
xbps-install -Syu # again
shutdown -r now
```
Log back in, run **ifconfig** to get your IP Address, SSH in and run the following commands

``` sh
   # utilities
   xbps-install -y bash git vim xorg rxvt-unicode zsh feh mpd wget
   ln -sf vim /usr/bin/vi

   # wm
   xbps-install -y bspwm sxhkd rofi dunst compton

   # polybar (installed at the end)
   xbps-install -y gcc cmake make libX11-devel xcb-util-devel xcb-util-image-devel \
       xcb-util-wm-devel alsa-lib-devel libmpdclient-devel wireless_tools-devel \
       libcurl-devel libXft-devel pkg-config
   git clone --recursive https://github.com/jaagr/polybar

   # termite (vte appears incompatible with latest void packages)
   #xbps-install -Sy git-all gcc make automake autoconf gtk-doc glib-devel vala-devel \
   #    gobject-introspection pkg-config intltool gettext-devel gnutls gtk+3 pango \
   #    gnutls-devel gtk+3-devel pango-devel gperf
   #mkdir build
   #cd build
   #git clone https://github.com/thestinger/vte-ng
   #cd vte-ng
   #./autogen.sh --prefix=/usr
   #make
   #make install
   #cd ..
   git clone --recursive https://github.com/thestinger/termite
   cd termite
   sed 's/PREFIX = \/usr\/local/PREFIX = \/usr/' -i Makefile
   make
   make install
   cd ~
   rm -rf ~/build

   # dots
   git clone --recursive https://github.com/lordmilko/dots
   shopt -s dotglob
   mv ~/dots/* ~/
   rm -rf ~/dots

   # Fonts
   xbps-install -Sy font-awesome envypn-font
   xbps-install -Sy font-unifont-bdf #maybe?
   wget https://raw.githubusercontent.com/googlei18n/noto-fonts/master/hinted/NotoSans-Regular.ttf -P ~/.fonts/
   wget https://raw.githubusercontent.com/mozilla/Fira/master/ttf/FiraMono-Regular.ttf -P ~/.fonts/
   wget https://raw.githubusercontent.com/google/material-design-icons/master/iconfont/MaterialIcons-Regular.ttf -P ~/.fonts/
   git clone https://github.com/sunaku/tamzen-font ~/.fonts/tamzen-font
   git clone https://github.com/stark/siji ~/.fonts/siji
   wget http://internode.dl.sourceforge.net/project/termsyn/termsyn-1.8.7.tar.gz
   tar xvf termsyn-1.8.7.tar.gz
   mkdir ~/.fonts/termsyn
   mv termsyn-1.8.7/*.pcf ~/.fonts/termsyn/
   rm -rf termsyn-1.8.7*
   mkfontdir ~/.fonts/termsyn/

   # finalization
   chmod +x ~/.local/bin/packages/themer/theme-activate
   mv ~/.bash_profile ~/.bash_profile.old
   mv ~/.bashrc ~/.bashrc.old
   shutdown -r now
   ```
   Build polybar
   ``` sh
   cd polybar
   ./build.sh #yes to everything but the first question (i3) and the last question (install example config)
   ```
   ``` sh
   # Launch wm
   wm_launcher
   # set theme
   ~/.local/bin/packages/themer/theme-activate darkpx
   ```

## Fedora

# Todo

* Writeup how to install all necessary packages
* zsh theme looks wrong
* Alias for themer
* Remove ~/themer
* Fix all themes
* Should Arch fonts be installed with X open first?
* Remove unnecessary vim themes
* Writeup zsh config works. it goes to zshrc, which gives us the .zsh folder, .zshrc, which runs all the zshrc.d files and sets the theme to jaagr. doesnt that conflict with the file zshrc.d/30-theme.zsh? whats meant to go in these $CURRENT_THEME/zsh files then!
* I think the #compdef in the _themer file indicates its related to zsh! check that out. somehow related to the zsh completion system?

# How it All Works
```
wm_launcher -> bootstrap
            -> X11(launch) -> xsession -> xsession.d\     -> 10-monitors
                                                          -> 30-appearance -> xresources/xresources(theme)
                                                          -> 35-fonts
                                                          -> 40-clipboard

                                       -> dunst(launch)   -> dunstrc
                                                          => dunst(theme)

                                       -> compton(launch) -> compton.conf
                                                          => compton(theme)

                                       -> sxhkd(launch)   -> sxhkd.sxhkdrc -> sxhkd.bspwm

                                       -> bspwm(launch)   -> bspwmrc       -> polybar(launch) => polybar(theme)
                                                          => wallpaper(theme)
                                                          => bspwm(theme)
```

Each module is loaded indirectly via a `launch` script. Each `launch` script prepares the environment for the module to be loaded. Each launch script is capable of being executed separately, however in normal operation they are chained together, starting with `wm_launcher`

`wm_launcher` (`~/.local/bin/wm_launcher`) loads a copy of the script bootstrapper (Shell Script Loader), displays a countdown and then executes the X11 `launch` (`~/.local/etc/xorg/launch`) script.

The X11 `launch` script initializes an X11 session using the `xsession` initialization script (`~/.local/etc/xorg/xsession`).

The `xsession` script executes all session related scripts under the `xsession.d` subdirectory (`~/.local/etc/xorg/xsession.d`), and then executes the dunst, compton, sxhkd and bspwm `launch` scripts (`~/.local/etc/<name>/launch -> ~/.config/<name>/launch`).

The bspwm `launch` script executes `bspwmrc` which in turn executes the polybar `launch` script. If a theme has been specified (`~/.local/etc/themer/current/bspwm`), bspwm will include that theme's settings in its bspwmrc

The polybar `launch` runs polybar and generates a `.runargs` script that can be used to reload polybar via a shortcut if desired.

When a theme is applied, the contents of themer/current directory (`~/.local/etc/themer/current/`) are replaced with symlinks to the components of the current theme (`~/.local/etc/themer/themes`)
