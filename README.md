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

Create a new VM with the following specs:

    * CPU: 2
    * RAM: 2GB
    * HDD: 30GB
    * OS: Linux/Other 3.x or Later (64-bit)
	
Boot the Arch Linux installation disk, then run

```sh
curl -O https://raw.githubusercontent.com/lordmilko/dots/master/ArchPreSetup1.sh
chmod +x ./ArchPreSetup1.sh
./ArchPreSetup1.sh
```
```sh
cd ~
./ArchPreSetup2.sh
```
Enter a password, then run
```sh
exit
systemctl reboot
```
Determine the timezone you wish to use with timedatectl list-timezones, then run

```sh
./ArchPostSetup.sh
```
```sh
shutdown -r now
```
Edit ~/.profile and make sure the Arch Linux MONITOR1 variable is the only MONITOR1 variable uncommented

If installing on a real machine, you can run `find /sys -name edid` to get an idea as to what the monitor name may need to be; otherwise you can use `xrandr` after starting X11 to get the actual name

Launch WM and set your theme
```sh
wm_launcher
~/.local/bin/packages/themer/theme-activate darkpx
```

If you encounter any issue during WM startup, logs can be found under `~/.cache`

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

If you'd like to have normal network interface names, before booting the install disk hit tab to edit the boot options, enter a space followed by `net.ifnames=0`

Under System, accept the installation destination and enter a hostname. Wait for the installation source to load, then under software selection select Minimal Install


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
* Vim airline themes. Does vim have a package manager? (https://github.com/vim-airline/vim-airline-themes)
* Remove colors- folder from .vim
* When you open something in darkpx and go to a different desktop, you get a circle instead of a custom icon. Go back to the theme the original icons came from and see how it handled it

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
