#!/bin/bash

# Read Xresources colors into an array
colors=($(xrdb -query | grep -E "^.*\.color[0-9]{1,2}: *" | awk -F'color' '{print $2}' | sort -V | awk '{sub(/^[0-9]+:[ \t]*/, ""); print}'))
background=$(xrdb -query | grep -E "^.*\.background: *" | awk -F':' '{print $2}'| awk '{sub(/^[ \t]*/, ""); print}')
foreground=$(xrdb -query | grep -E "^.*\.foreground: *" | awk -F':' '{print $2}'| awk '{sub(/^[ \t]*/, ""); print}')

# Check if colors array has 16 elements (color0-color15)
if [ ${#colors[@]} -ne 16 ]; then
  echo "Error: Expected 16 colors, found ${#colors[@]}." >&2
  exit 1
fi

# Assign to Polybar variables (adjust mappings to match your theme!)
cat <<EOF
; Polybar colors generated from .Xresources ($(date))
[colors]
background = ${background}
background-alt = ${colors[0]}  ; or another color (e.g., color8)
foreground = ${foreground}
primary = ${colors[4]}         ; e.g., color4 for primary
secondary = ${colors[2]}       ; e.g., color2 for secondary
alert = ${colors[1]}           ; e.g., color1 for alert
disabled = ${colors[6]}        ; e.g., color6 for disabled
EOF
