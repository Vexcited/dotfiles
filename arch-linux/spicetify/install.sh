#!/bin/sh

# Taken from Comfy.
# https://github.com/NYRI4/Comfy-spicetify/blob/main/install.sh

set -e

echo "Downloading..."

# Setup directories to download to
theme_dir="$(dirname "$(spicetify -c)")/Themes/Comfy"
ext_dir="$(dirname "$(spicetify -c)")/Extensions"

# Make directories if needed
mkdir -p "${theme_dir}"
mkdir -p "${ext_dir}"

# Symlink the color.ini file
rm -rf "${theme_dir}/color.ini"
ln -sf $HOME/.vexcited-dotfiles/arch-linux/spicetify/color.ini "${theme_dir}/color.ini"

# Download latest tagged files into correct directories
curl --progress-bar --output "${theme_dir}/user.css" "https://raw.githubusercontent.com/NYRI4/Comfy-spicetify/main/user.css"
curl --progress-bar --output "${ext_dir}/Comfy.js" "https://raw.githubusercontent.com/NYRI4/Comfy-spicetify/main/Comfy.js"

echo "Applying theme..."
spicetify config extensions Comfy.js
spicetify config current_theme Comfy color_scheme Comfy
spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
spicetify apply

echo "All done !"

