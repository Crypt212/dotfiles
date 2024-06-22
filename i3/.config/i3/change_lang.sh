#!/bin/bash

query=$(setxkbmap -query | awk 'NR == 3 {print $2}')
if [ $query = 'ara' ]; then
	setxkbmap -layout us
else
	setxkbmap -layout ara
fi

