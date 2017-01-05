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
4. Install fonts
5. Run **wm_launcher**
6. win+enter
7. chmod +x ~/themer
8. ~/themer space
9. Edit ~/.profile and up the top swap the export MONITOR1 variable based on your distro. If you want to set this to something else, under X to **xrandr** and observe the output name

## Packages

### Arch Linux

### Void Linux

``` sh
xbps-install rofi dunst compton

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
```

### Fedora

## Todo

* Writeup how to install all necessary packages
* Change vim colors to submodules if possible?
    * How do you have a folder thats a submodule and a file under it that is in a different module
* Fixup aliases
* Remove ~/themer
* Remove unnecessary vim themes

## How it All Works
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
