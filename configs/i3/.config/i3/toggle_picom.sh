#!/bin/bash

running=$(ps aux | awk '$11 == "picom" {print 1}')
if [ -z $running ]; then
	source $HOME/.config/picom/launch.sh
else
	pkill "picom"
fi
