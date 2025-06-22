#!/bin/bash

echo "Choose setup with i3 or bspwm? [i,b]"
read setup

echo "Install or uninstall? [i,u]"
read install

pacman -S stow git --needed --noconfirm

if [ $install = 'i' ]; then
	if [ $setup = 'i' ]; then stow i3 -d "$SCRIPT_DIR/to-stow" -t ~
	elif [ $setup = 'b' ]; then stow bspwm -d "$SCRIPT_DIR/to-stow" -t ~
	fi

	if [ $setup = 'i' ]; then pacman -S i3-wm i3lock-color --needed --noconfirm
	elif [ $setup = 'b' ]; then pacman -S bspwm sxhkd --needed --noconfirm
	fi
else
	if [ $setup = 'i' ]; then stow -D i3 -d "$SCRIPT_DIR/to-stow" -t ~
	elif [ $setup = 'b' ]; then stow -D bspwm -d "$SCRIPT_DIR/to-stow" -t ~
	fi

	if [ $setup = 'i' ]; then pacman -Rns i3-wm i3lock-color --noconfirm
	elif [ $setup = 'b' ]; then pacman -Rns bspwm sxhkd --noconfirm
	fi
fi

# Fonts
ft_dir=$($PWD/no-stow/fonts/)
fonts=$(ls $ft_dir | awk -F '.' 'print $2')
echo $font | xargs -n 1 -I {} unzip $ft_dir/{}.zip -d {}
mv $ft_dir/*/ /usr/share/fonts/
