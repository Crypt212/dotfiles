# Helper function to prompt user for package categories
choose() {
  local categories=("$@")
  
  # Prompt user to select a category
  echo "Select a category:"
  local selected_category
  selected_category=$(printf "%s\n" "${categories[@]}" | fzf --header="Select a category" --height=10)

  if [[ -z "$selected_category" ]]; then
    echo "No category selected."
    return
  fi

  # Get packages for the selected category
  local package_dir="./to-stow/$selected_category"
  if [[ ! -d "$package_dir" ]]; then
    echo "No packages found for category: $selected_category"
    return
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
    echo "You selected the following packages:"
    printf "%s\n" "$selected_packages"
    # Convert the selected packages into an array
    IFS=$'\n' read -r -d '' -a selected <<< "$selected_packages"
    printf "%s\n" "${selected[@]}"
  else
    echo "No packages selected."
  fi
}

echo "returns " $(choose "editors" "veiwers")

