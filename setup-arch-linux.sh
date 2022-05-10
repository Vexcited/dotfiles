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

echo "Installing cool packages... (it will maybe ask you a password)"
sudo pacman -Syu
sudo pacman -S \
  github-cli \
  xdg-utils \
  neovim \
  discord \
  alacritty \
  zsh \
  curl \
  wget \
  pkgconf \
  xmonad \
  xmonad-contrib \
  xmobar \
  picom \
  feh \
  rofi \
  xdotool \ 
  trayer

echo "Installing yay..."
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay-git.git && cd yay-git
makepkg -si && cd .. && rm -rf yay-git

echo "Installing Hack Nerd Font..."
yay -S nerd-fonts-hack

echo "Login to GitHub... Follow the instructions given by the GitHub CLI."
gh auth login

echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "Installing powerlevel10k omz theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$Hcustom}/themes/powerlevel10k

echo "Installing NVM..."
yay -S nvm

echo "Installing Google Chrome"
yay -S google-chrome

echo "Symlinking dotfiles..."
mkdir -p $HOME/.config

# Xorg
echo -e "\tSyncing xorg..."
ln -s $DOTFILES/xorg/Xresources $HOME/.Xresources
ln -s $DOTFILES/xorg/xinitrc $HOME/.xinitrc

# Alacritty
echo -e "\tSyncing alacritty... (directory - in ~/.config/alacritty - is removed)"
rm -rf $HOME/.config/alacritty
ln -s $DOTFILES/alacritty $HOME/.config/alacritty

# Bash
echo -e "\tSyncing bash... (default configurations - in ~/.bashrc and ~/.bash_profile - are removed)"
rm -rf $HOME/.bashrc $HOME/.bash_profile
ln -s $DOTFILES/bash/bashrc $HOME/.bashrc
ln -s $DOTFILES/bash/bash_profile $HOME/.bash_profile

# ZSH
echo -e "\tSyncing zsh... (default configurations - in ~/.zshrc and ~/.zprofile - are removed)"
rm -rf $HOME/.zshrc $HOME/.zprofile
ln -s $DOTFILES/zsh/zshrc $HOME/.zshrc
ln -s $DOTFILES/zsh/zprofile $HOME/.zprofile
ln -s $DOTFILES/zsh/p10k.zsh $HOME/.p10k.zsh

# Xmonad
echo -e "\tSyncing xmonad... (default configuration - in ~/.xmonad - is removed)"
rm -rf $HOME/.xmonad
ln -s $DOTFILES/xmonad $HOME/.xmonad
chmod +x $HOME/.xmonad/scripts/switchlayout.sh
chmod +x $HOME/.xmonad/scripts/trayer.sh

# Rofi
echo -e "\tSyncing rofi..."
rm -rf $HOME/.config/rofi
ln -s $DOTFILES/rofi $HOME/.config/rofi

# Picom
echo -e "\tSyncing picom..."
rm -rf $HOME/.config/picom
ln -s $DOTFILES/picom $HOME/.config/picom

# Xmobar
echo -e "\tSyncing xmobar..."
rm -rf $HOME/.config/xmobar
ln -s $DOTFILES/xmobar $HOME/.config/xmobar
chmod +x $HOME/.config/xmobar/scripts/getlayout.sh
chmod +x $HOME/.config/xmobar/scripts/trayer-padding-icon.sh

echo "Add Node LTS to NVM..."
source /usr/share/nvm/init-nvm.sh
nvm install --lts
nvm use --lts

echo "Installing Vim-Plug..."
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo -e "\tSyncing nvim..."
mkdir -p $HOME/.config/nvim
rm -rf $HOME/.config/nvim/init.vim
ln -S $DOFTFILES/nvim/init.vim $HOME/.config/nvim/init.vim

echo "Done ! The system will reboot now..."
sudo reboot
