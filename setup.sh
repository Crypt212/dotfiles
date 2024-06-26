#!/bin/bash

echo "Do you want to setup with i3 or bspwm? [i,b]"
read setup

dirs=$(ls -l | grep '^d' | awk '$NF != "no-stow" && $NF != "i3" && $NF != "bspwm" {print $NF}')
pacman -S stow git

if [ $setup = 'i' ]; then stow i3
elif [ $setup = 'b' ]; then stow bspwm
fi

echo $dirs | xargs -n 1 -I {} stow {} -R

# Base
pacman -S xorg

# Dev
pacman -S curl nodejs g++ gcc 

# Disktop 
if [ $setup = 'i' ]; then pacman -S i3-wm i3lock-color
elif [ $setup = 'b' ]; then pacman -S bspwm sxhkd
fi

pacman -S polybar picom rofi nitrogen

# Editing
pacman -S alacritty neovim gimp scrot qutebrowser 

# Social
pacman -S discord telegram-desktop thunderbird

# MISC
pacman -S unzip


# Fonts
ft_dir=$($PWD/no-stow/fonts/)
fonts=$(ls $ft_dir | awk -F '.' 'print $2')

echo $font | xargs -n 1 -I {} unzip $ft_dir/{}.zip -d {}
mv $ft_dir/*/ /usr/share/fonts/
