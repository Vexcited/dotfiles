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

  if pacman -Qi $package &> /dev/null ; then
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
  "alsa-utils"
  "xdg-utils"
  
  "neovim"
  "alacritty"
  
  "zsh"
  "zsh-syntax-highlighting"
  "zsh-autosuggestions"

  "zip"
  "unzip"
  "curl"
  "wget"
  "pkgconf"

  "xorg-server" "xorg-apps" "xorg-xinit" "xorg-xmessage"
  "libx11" "libxft" "libxinerama" "libxrandr" "libxss"
  "stack"
  "xmobar"
  
  "trayer"
  "picom"
  "feh"

  "xdotool" 
  "libinput"

  "gnome-keyring"
  "libsecret"
  "libgnome-keyring"

  "flameshot"
  "nautilus"
  "rofi"

  "pulseaudio" "pulseaudio-alsa" "pulseaudio-bluetooth"
  "pulsemixer" "pavucontrol"

  "bluez" "bluez-utils"

  "noto-fonts-emoji" "noto-fonts" "noto-fonts-cjk" "noto-fonts-extra"
  "papirus-icon-theme"

  "libnotify"
  "dunst"
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

install_aur () {
  package=$1

  if yay -Qi $package &> /dev/null ; then
    echo -e "\t$package is installed. Skipping."
  else
    echo -e "\t$package is not installed. Installing..."
    yay -S $package
  fi
}

install_aur nerd-fonts-hack

if [ ! -d $HOME/.oh-my-zsh ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ ! -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k ]; then
  echo "Installing powerlevel10k oh-my-zsh custom theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k

  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

install_aur nvm

install_aur visual-studio-code-bin
echo "Installing VS Code extensions..."
code --install-extension "icrawl.discord-vscode"
code --install-extension "marlosirapuan.nord-deep"
code --install-extension "dbaeumer.vscode-eslint"

install_aur ly
echo "Enabling ly service..."
sudo systemctl enable ly.service

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
create_symlink $DOTFILES/zsh/p10k.zsh $HOME/.p10k.zsh

# Xmonad
echo -e "\tSyncing xmonad and its scripts ($HOME/.config/xmonad will be removed)..."
rm -rf $HOME/.config/xmonad
create_symlink $DOTFILES/xmonad $HOME/.config/xmonad
if [ ! -f $HOME/.local/bin/xmonad ]; then
  echo -e "\tInstalling xmonad with stack..."
  cd $HOME/.config/xmonad && stack install && cd $HOME/.vexcited-dotfiles
  sudo ln -sf $HOME/.local/bin/xmonad /usr/bin
fi
chmod +x $HOME/.config/xmonad/scripts/switchlayout.sh
chmod +x $HOME/.config/xmonad/scripts/trayer.sh

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
chmod +x $HOME/.config/xmobar/scripts/trayer-padding-icon.sh

# Flameshot
echo -e "\tSyncing flameshot..."
mkdir -p $HOME/.config/flameshot
create_symlink $DOTFILES/flameshot/flameshot.ini $HOME/.config/flameshot/flameshot.ini

# Dunst
echo -e "\tSyncing dunst..."
mkdir -p $HOME/.config/dunst
create_symlink $DOTFILES/dunst/dunstrc $HOME/.config/dunst/dunstrc

# GTK
echo -e "\tSyncing gtk..."
touch $HOME/.gtk-bookmarks # Fix errors about bookmarks in Nautilus.
create_symlink $DOTFILES/gtk/config/gtkrc-2.0 $HOME/.gtkrc-2.0
mkdir -p $HOME/.config/gtk-3.0
create_symlink $DOTFILES/gtk/config/gtk-3.0/settings.ini $HOME/.config/gtk-3.0/settings.ini
mkdir -p $HOME/.themes
create_symlink $DOTFILES/gtk/themes/Nordic $HOME/.themes/Nordic
gsettings set org.gnome.desktop.interface gtk-theme "Nordic"
gsettings set org.gnome.desktop.wm.preferences theme "Nordic"
cd $DOTFILES/gtk/icons/Papirus-Nord && chmod +x ./install && yes N | sudo ./install && cd $HOME/.vexcited-dotfiles
papirus-folders -C frostblue3 --theme Papirus-Dark

echo "Add Node LTS to NVM..."
source /usr/share/nvm/init-nvm.sh
nvm install --lts
nvm use --lts

vim_plug_install_path="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim
if [ ! -f $vim_plug_install_path ]; then
  echo "Installing Vim-Plug..."
  sh -c "curl -fLo $vim_plug_install_path --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
fi

echo -e "\tSyncing nvim..."
mkdir -p $HOME/.config/nvim
create_symlink $DOTFILES/nvim/init.vim $HOME/.config/nvim/init.vim
nvim +"PlugInstall" +qall
nvim +"CocInstall -sync coc-tsserver coc-json coc-eslint coc-html coc-css" +qall
nvim +"CocUpdateSync" +qall

echo "Enable notifications daemon..."
dunstctl set-paused false

echo "Enable bluetooth service..."
sudo systemctl enable bluetooth.service

clear
echo "Done ! All the configuration was symlinked and installed."
echo "Now, please reboot your computer with by running"
echo -e "\tsudo reboot"
echo ""
echo "On startup, the ly display manger will automatically load to prompt login."
echo "Select 'xinitrc' as window manager to make sure it loads the config from '~/.xinitrc'."
echo "More informations on https://github.com/vexcited/dotfiles"
