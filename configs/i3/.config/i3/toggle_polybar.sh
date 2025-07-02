#!/bin/bash

running=$(ps aux | awk '$11 == "polybar" {print 1}')
if [ -z $running ]; then
	source $HOME/.config/polybar/launch.sh
else
	pkill "polybar"
fi
