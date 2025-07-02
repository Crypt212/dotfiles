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

# Assign to i3 variables (adjust indices to match your theme preferences)
# Example mapping:
#   client.focused          <border> <bg> <text> <indicator> <child_border>
#   client.unfocused        <border> <bg> <text> <indicator> <child_border>
#   client.focused_inactive <border> <bg> <text> <indicator> <child_border>
#   client.urgent           <border> <bg> <text> <indicator> <child_border>

cat <<EOF
# i3 colors generated from .Xresources ($(date))
client.focused          ${colors[4]} ${background} ${foreground} ${colors[2]} ${colors[5]}
client.unfocused        ${colors[8]} ${colors[0]}  ${colors[15]} ${colors[8]} ${colors[0]}
client.focused_inactive ${colors[8]} ${colors[0]}  ${colors[15]} ${colors[8]} ${colors[0]}
client.urgent           ${colors[1]} ${colors[0]}  ${colors[15]} ${colors[1]} ${colors[0]}
EOF
