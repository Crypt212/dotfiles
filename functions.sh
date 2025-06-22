#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure stow and git are installed
install_dependencies() {
  if ! command -v stow &> /dev/null || ! command -v git &> /dev/null; then
    echo "Installing stow and git..."
    sudo pacman -S stow git --needed --noconfirm
  else
    echo "stow and git are already installed."
  fi
}

# Helper function to prompt user for package categories
choose() {
  local categories=("$@")
  
  # Prompt user to select a category
  local selected_category
  selected_category=$(printf "%s\n" "${categories[@]}" | fzf --header="Select a category" --height=10)

  if [[ -z "$selected_category" ]]; then
    echo "No category selected."
    return 1  # Return an error code
  fi

  # Get packages for the selected category
  local package_dir="$SCRIPT_DIR/to-stow/$selected_category"
  if [[ ! -d "$package_dir" ]]; then
    echo "No packages found for category: $selected_category"
    return 1  # Return an error code
  fi

  # List packages in the selected category
  local packages=()
  while IFS= read -r -d '' file; do
    packages+=("$(basename "$file")")
  done < <(find "$package_dir" -mindepth 1 -maxdepth 1 -type d -print0)

  # Use fzf to select packages interactively
  local selected_packages
  selected_packages=$(printf "%s\n" "${packages[@]}" | fzf --header="Select packages (Press TAB to select, Enter to confirm)" --multi --height=20)

  if [[ -n "$selected_packages" ]]; then
    # Convert the selected packages into an array
    IFS=$'\n' read -r -d '' -a selected <<< "$selected_packages"
    echo "${selected[@]} $selected_category"  # Return the selected packages
  else
    echo "No packages selected."
    return 1  # Return an error code
  fi
}

# Install packages and stow
install() {
local packages=("$@")
local category="${packages[-1]}"  # Get the last element as the category
unset 'packages[-1]'               # Remove the last element from the packages array
  for pack in "${packages[@]}"; do
      echo "Installing $category/$pack..."
    sudo pacman -S --needed --noconfirm "$pack"
    if [[ -d "$SCRIPT_DIR/to-stow/$category/$pack" ]]; then
      echo "Stowing $category/$pack..."
      stow -d "$SCRIPT_DIR/to-stow/$category" -t ~ "$pack"
    else
      echo "Warning: Stow directory for $category/$pack not found."
    fi
  done
}

# Uninstall packages and unstow
uninstall() {
local packages=("$@")
local category="${packages[-1]}"  # Get the last element as the category
unset 'packages[-1]'               # Remove the last element from the packages array
  for pack in "${packages[@]}"; do
    if [[ -d "$SCRIPT_DIR/to-stow/$category/$pack" ]]; then
      echo "Unstowing $category/$pack..."
      stow -D -d "$SCRIPT_DIR/to-stow/$category" -t ~ "$pack"
    else
      echo "Warning: Stow directory for $category/$pack not found."
    fi
    echo "Removing $category/$pack..."
    if pacman -Qi "$pack" &>/dev/null; then
      sudo pacman -Rns --noconfirm "$pack"
    else
      echo "Package $category/$pack is not installed."
    fi
  done
}

# Install fonts
install_fonts() {
  local ft_dir="$SCRIPT_DIR/no-stow/fonts/"
  
  if [[ ! -d "$ft_dir" ]]; then
    echo "Font directory $ft_dir does not exist."
    return
  fi

  local font_files=()
  while IFS= read -r -d '' file; do
    font_files+=("$(basename "$file" .zip)")
  done < <(find "$ft_dir" -name '*.zip' -print0 )

  local selected_fonts=()
  selected_fonts=($(choose "${font_files[@]}" "Fonts"))

  for font in "${selected_fonts[@]}"; do
    case $action in
      install)
        echo "Installing font: $font"
        unzip -o "$ft_dir/$font.zip" -d "$HOME/Fonts/"
        sudo cp -u "$HOME/Fonts/$font/*" /usr/share/fonts/
        ;;
      uninstall)
        echo "Uninstalling font: $font"
        rm -rf "$HOME/Fonts/$font"
        sudo rm -rf "/usr/share/fonts/$font"
        ;;
      *)
        echo "Invalid action for fonts."
        ;;
    esac
  done
}

# Install wallpapers
install_wallpapers() {
  local wp_dir="$SCRIPT_DIR/no-stow/wallpapers/"
  
  if [[ ! -d "$wp_dir" ]]; then
    echo "Wallpapers directory $wp_dir does not exist."
    return
  fi

  local wallpaper_files=()
  while IFS= read -r -d '' file; do
    wallpaper_files+=("$(basename "$file" .png)")
  done < <(find "$wp_dir" -name '*.png' -print0)

  local selected_wallpapers=()
  selected_wallpapers=($(choose "${wallpaper_files[@]}" "Wallpapers"))

  for wallpaper in "${selected_wallpapers[@]}"; do
    case $action in
      install)
        echo "Installing wallpaper: $wallpaper"
        cp -u "$wp_dir$wallpaper.png" "$HOME/Wallpapers/"
        ;;
      uninstall)
        echo "Uninstalling wallpaper: $wallpaper"
        rm -f "$HOME/Wallpapers/$wallpaper.png"
        ;;
      *)
        echo "Invalid action for wallpapers."
        ;;
    esac
  done
}
