#!/bin/sh

echo "-- Welcome to the Arch-Linux setup of Vexcited's dotfiles."
echo -e "Configuration from https://github.com/vexcited/dotfiles\n"

echo "Checking if dotfiles directory exists..." 
DOTFILES=$HOME/.vexcited-dotfiles/arch-linux
if [ ! -d "$DOTFILES" ];
then
  echo "$DOTFILES directory doesn't exist ! Make sure you've cloned into $DOTFILES, else this script won't work."
  exit 1
fi

echo "Installing cool packages..."
sudo pacman -Syu
sudo pacman -S \
  github-cli \
  xdg-utils \
  neovim \
  discord \
  alacritty

echo "Installing yay..."
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay-git.git && cd yay-git
makepkg -si && cd .. && rm -rf yay-git

echo "Installing Hack nerd font..."
yay -S nerd-fonts-hack

echo "Login to GitHub... Follow the instructions given by the GitHub CLI."
gh auth login

echo "Symlinking dotfiles..."

# Xorg
echoe -e "\tSyncing xorg..."
ln -s $DOTFILES/xorg/Xresources $HOME/.Xresources
ln -s $DOTFILES/xorg/xinitrc $HOME/.xinitrc

# Alacritty
echo -e "\tSyncing alacritty..."
mkdir -p $HOME/.config/alacritty
ln -s $DOTFILES/alacritty/alacritty.yml $HOME/.config/alacritty/.alacritty.yml

# Bash
echo -e "\tSyncing bash..."
ln -s $DOTFILES/bash/bashrc $HOME/.bashrc
ln -s $DOTFILES/bash/bash_profile $HOME/.bash_profile

echo "Done !"
exit 0
