#!/bin/bash

~/.config/polybar/xresources-to-polybar.sh > ~/.config/polybar/colors.polybar

killall polybar 
polybar bar1 &
polybar bar2 &
