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
6. chmod +x ~/.local/bin/packages/themer/theme-activate
7. ~/.local/bin/packages/themer/theme-activate space

## Packages

### Arch Linux

### Void Linux

``` sh
# Fonts
xbps-install -S font-awesome
wget https://raw.githubusercontent.com/googlei18n/noto-fonts/master/hinted/NotoSans-Regular.ttf -P ~/.fonts/
```

### Fedora

## Todo

* Writeup how to install all necessary packages
* Change vim colors to submodules if possible?
	* How do you have a folder thats a submodule and a file under it that is in a different module
* Fixup aliases
* Remove ~/themer