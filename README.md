This repo is a fork of jaagr's dotfile/themer configuration, complete with necessary instructions to get it up and running in a VMware environment for testing purposes.

[Incomplete]

## Enhancements
* Creates gitignored directories (.cache, .wallpapers)
* Includes vim color schemes
* Includes necessary shell scripts/bugfixes
* Removes settings specific to jaagr's PC

## Installation

1. TODO: how to install all necessary packages
2. rm -rf ~/* && rm -rf ~/.* # warning! this will delete everything in ~
3. git clone --recursive https://github.com/lordmilko/dots ~/
4. Run **wm_launcher**
5. win+enter
6. chmod +x ~/themer
7. ~/themer space
8. Edit ~/.profile and up the top swap the export MONITOR1 variable based on your distro. If you want to set this to something else, under X to **xrandr** and observe the output name

## Packages

### Arch Linux

### Void Linux

``` sh
xbps-install rofi dunst compton

# Fonts
xbps-install -S font-awesome envypn-font
xbps-install -S font-unifont-bdf #maybe?
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
mkfontcache ~/.fonts/termsyn/
```

### Fedora

## Todo

* Writeup how to install all necessary packages
* Change vim colors to submodules if possible?
	* How do you have a folder thats a submodule and a file under it that is in a different module
* Fixup aliases
* Remove ~/themer