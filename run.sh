#!/bin/bash

# Source the functions file
source "$(dirname "${BASH_SOURCE[0]}")/functions.sh"

# Ensure dependencies are installed
install_dependencies

# Main script
echo "What would you like to do?"
echo "1. Manage packages"
echo "2. Manage fonts"
echo "3. Manage wallpapers"
read -p "Please enter the number corresponding to your choice: " choice

case $choice in
  1)  # Package management
    read -p "Would you like to install or uninstall the packages? 'install' or 'uninstall': " action
    if [[ "$action" == "install" || "$action" == "uninstall" ]]; then
      categories=()
      while IFS= read -r -d '' dir; do
        categories+=("$(basename "$dir")")
      done < <(find "$SCRIPT_DIR/to-stow" -mindepth 1 -maxdepth 1 -type d -print0)

      selected=$(choose "${categories[@]}")

	if [[ $? -eq 0 ]]; then  # Check if choose was successful
	  echo ${selected[@]}
	  if [[ "$action" == "install" ]]; then
	    install ${selected[@]}
	  elif [[ "$action" == "uninstall" ]]; then
	    uninstall ${selected[@]}
	  fi
	else
	  echo "No valid selection was made."
	fi
    else
      echo "Invalid action. Please enter 'install' or 'uninstall'."
    fi
    ;;
  2)  # Font management
    read -p "Do you want to install or uninstall fonts? [install/uninstall]: " action
    if [[ "$action" == "install" || "$action" == "uninstall" ]]; then
      install_fonts
    else
      echo "Invalid action. Please enter 'install' or 'uninstall'."
    fi
    ;;
  3)  # Wallpaper management
    read -p "Do you want to install or uninstall wallpapers? [install/uninstall]: " action
    if [[ "$action" == "install" || "$action" == "uninstall" ]]; then
      install_wallpapers
    else
      echo "Invalid action. Please enter 'install' or 'uninstall'."
    fi
    ;;
  *) 
    echo "Invalid choice. Please select a valid option."
    ;;
esac
