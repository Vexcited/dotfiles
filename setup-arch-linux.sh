#!/bin/sh

clear
echo "-- Welcome to the Arch-Linux setup of Vexcited's dotfiles."
echo -e "Configuration from https://github.com/vexcited/dotfiles\n"

echo "Checking if dotfiles directory exists..." 
DOTFILES=$HOME/.vexcited-dotfiles/arch-linux
if [ ! -d "$DOTFILES" ]; then
  echo "$DOTFILES directory doesn't exist ! Make sure you've cloned into $DOTFILES, else this script won't work."
  exit 1
fi

echo "Installing pacman packages... (it will maybe ask you a password)"

install_package () {
  package=$1

  if pacman -Qi $package > /dev/null ; then
    echo -e "\t$package is installed. Skipping."
  else
    echo -e "\t$package is not installed. Installing..."
    sudo pacman -S $package
  fi
}

# Update and upgrade.
sudo pacman -Syu

packages_to_install=(
  "github-cli"
  "xdg-utils"
  "neovim"
  "alacritty"
  "zsh"
  "curl"
  "wget"
  "pkgconf"

  # Window Manager
  "xmonad"
  "xmonad-contrib"
  "xmobar"

  "picom"

  # Wallpaper
  "feh"

  # Launcher
  "rofi"

  "xdotool" 
  "git"
  "zsh"
  "alsa-utils"
  "libinput"

  "gnome-keyring"
  "libsecret"
  "libgnome-keyring"

  # Screenshot
  "flameshot"

  # PulseAudio
  "pulseaudio" "pulseaudio-alsa" "pulseaudio-bluetooth"
  "pulsemixer" "pavucontrol"
  
  # Fix special chars problems
  "noto-fonts" "noto-fonts-cjk" "noto-fonts-extra"
)

for package in ${packages_to_install[@]}; do
  install_package $package
done

if ! command -v yay &> /dev/null; then
  echo "'yay' not found. Installing it..."

  git clone https://aur.archlinux.org/yay-git.git && \
  cd yay-git && makepkg -si && \
  cd .. && rm -rf yay-git
fi

echo "Installing Hack Nerd Font..."
yay -S nerd-fonts-hack

echo "Installing trayer-srg..."
yay -S trayer-srg

if [ ! -d $HOME/.oh-my-zsh ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ ! -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k ]; then
  echo "Installing powerlevel10k oh-my-zsh custom theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
fi

if ! command -v nvm &> /dev/null; then
  echo "Installing NVM..."
  yay -S nvm
fi

if ! command -v code &> /dev/null; then
  echo "Installing Visual Studio Code..."
  yay -S visual-studio-code-bin
fi

if ! command -v ly &> /dev/null; then
  echo "Installing ly (display manager to login)..."
  yay -S ly

  echo "Enabling ly service..."
  sudo systemctl enable ly.service
fi

echo "Symlinking dotfiles..."
mkdir -p $HOME/.config

create_symlink () {
  dotfilesLink=$1
  targetLink=$2

  if [[ -L "$targetLink" ]]; then
    if [[ -e "$targetLink" ]]; then
      if [[ $(readlink $targetLink) == $dotfilesLink ]]; then
        echo "'$targetLink' already exists. Skipping..."
      else
	      echo "'$targetLink' is alrady linked to another file. Replacing it..."
	      ln -sf $dotfilesLink $targetLink
      fi
    else
      echo "'$targetLink' link was broken. Creating a new one..."
      rm -rf $targetLink
      ln -sf $dotfilesLink $targetLink
    fi
  else
    echo "'$targetLink' doesn't exists. Creating it..."
    ln -sf $dotfilesLink $targetLink
  fi
}

# Xorg
echo -e "\tSyncing xorg..."
create_symlink $DOTFILES/xorg/Xresources $HOME/.Xresources
create_symlink $DOTFILES/xorg/xinitrc $HOME/.xinitrc
chmod +x $HOME/.xinitrc

# Alacritty
echo -e "\tSyncing alacritty..."
mkdir -p $HOME/.config/alacritty
create_symlink $DOTFILES/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml

# sh (.aliases)
echo -e "\tSyncing sh (.aliases)..."
create_symlink $DOTFILES/sh/aliases $HOME/.aliases

# Bash
echo -e "\tSyncing bash..."
create_symlink $DOTFILES/bash/bashrc $HOME/.bashrc
create_symlink $DOTFILES/bash/bash_profile $HOME/.bash_profile

# ZSH
echo -e "\tSyncing zsh..."
create_symlink $DOTFILES/zsh/zshrc $HOME/.zshrc
create_symlink $DOTFILES/zsh/zprofile $HOME/.zprofile
create_symlink $DOTFILES/zsh/p10k.zsh $HOME/.p10k.zsh

# Xmonad
echo -e "\tSyncing xmonad and its scripts..."
mkdir -p $HOME/.xmonad
create_symlink $DOTFILES/xmonad/xmonad.hs $HOME/.xmonad/xmonad.hs
create_symlink $DOTFILES/xmonad/scripts $HOME/.xmonad/scripts
chmod +x $HOME/.xmonad/scripts/switchlayout.sh
chmod +x $HOME/.xmonad/scripts/trayer.sh

# Rofi
echo -e "\tSyncing rofi..."
mkdir -p $HOME/.config/rofi
create_symlink $DOTFILES/rofi/config.rasi $HOME/.config/rofi/config.rasi
create_symlink $DOTFILES/rofi/nord.rasi $HOME/.config/rofi/nord.rasi

# Picom
echo -e "\tSyncing picom..."
mkdir -p $HOME/.config/picom
create_symlink $DOTFILES/picom/picom.conf $HOME/.config/picom/picom.conf

# Xmobar
echo -e "\tSyncing xmobar..."
mkdir -p $HOME/.config/xmobar
create_symlink $DOTFILES/xmobar/xmobarrc $HOME/.config/xmobar/xmobarrc
create_symlink $DOTFILES/xmobar/scripts $HOME/.config/xmobar/scripts
chmod +x $HOME/.config/xmobar/scripts/getlayout.sh
chmod +x $HOME/.config/xmobar/scripts/trayer-padding-icon.sh
chmod +x $HOME/.config/xmobar/scripts/getvolume.sh

echo "Add Node LTS to NVM..."
source /usr/share/nvm/init-nvm.sh
nvm install --lts
nvm use --lts

echo "Installing Vim-Plug..."
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo -e "\tSyncing nvim..."
mkdir -p $HOME/.config/nvim
create_symlink $DOTFILES/nvim/init.vim $HOME/.config/nvim/init.vim
nvim +"PlugInstall" +qall
nvim +"CocInstall -sync coc-tsserver coc-json coc-eslint coc-html coc-css" +qall
nvim +"CocUpdateSync" +qall

clear
echo "Done ! All the configuration was symlinked and installed."
echo "Now, please reboot your computer with by running"
echo -e "\tsudo reboot"
echo ""
echo "On login, the DE will automatically load."
echo "More informations on https://github.com/vexcited/dotfiles"
