#!/usr/bin/env bash
clear

echo "/**"
echo " * Vexcited's .files / Termux"
echo " * https://github.com/Vexcited/dotfiles"
echo -e " */\n"

echo -e "\n// Check existence of '~/.vexcited-dotfiles' directory."
DOTFILES=$HOME/.vexcited-dotfiles/termux
if [ ! -d "$DOTFILES" ]; then
  echo "ERROR: $DOTFILES directory doesn't exist !"
  echo "ERROR: Make sure you've cloned the repository into '$DOTFILES'."
  exit 1
fi
echo "Ok!"

echo -e "\n// Install required packages."
pkg upgrade -y && pkg install -y git dialog

echo -e "\n// Pull latest commits - if available."
git pull

dialog --yesno \
  "Run 'termux-change-repo'?\n\nIf yes, then select 'Mirror Group' and then select the servers location that is best for you - Europe servers for me." \
  20 60 && \
  termux-change-repo
clear # Clear any dialog.

echo "// Install cool packages."
pkg install -y \
  nano \
  wget \
  curl \
  lsd \
  zsh \
  zip \
  unzip \
  openssh \
  gh \
  nodejs \
  python \
  neovim-nightly

echo -e "\n// Initialize global 'git' configuration."
git config --global user.name "Mikkel RINGAUD"
git config --global user.email "mikkel@milescode.dev"

echo -e "// Install some npm packages globally."
npm i -g pnpm yarn vercel

dialog --yesno \
  "Authenticate to GitHub using their CLI?" \
  20 60 && clear && \
  gh auth login -p https -w -s codespace,write:gpg_key
clear # Clear any dialog.

if [ ! -d $HOME/.oh-my-zsh ]; then
  echo -e "\n// Install 'oh-my-zsh'."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ ! -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k ]; then
  echo -e "\n// Install PowerLevel10k theme for 'oh-my-zsh'."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
fi

if [ ! -d $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
  echo -e "\n// Install 'zsh-syntax-highlighting'."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

if [ ! -d $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
  echo -e "\n// Install 'zsh-autosuggestions'."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

if [ ! -f $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
  echo -e "\n// Install 'vim-plug'."
  sh -c 'curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

echo -e "\n// Linking configuration..."
mkdir -p $HOME/.config

create_symlink () {
  dotfilesLink=$1
  targetLink=$2

  if [[ -L "$targetLink" ]]; then
    if [[ -e "$targetLink" ]]; then
      if [[ $(readlink $targetLink) == $dotfilesLink ]]; then
        echo "SKIP: '$targetLink' is already linked."
      else
        echo "OVERWRITE: '$targetLink' is linked to another file."
        ln -sf $dotfilesLink $targetLink
      fi
    else
      echo "BROKEN: '$targetLink' link is going to be re-created."
      rm -rf $targetLink
      ln -sf $dotfilesLink $targetLink
    fi
  else
    echo "NEW: '$targetLink'."
    ln -sf $dotfilesLink $targetLink
  fi
}

echo -e "\t- Migrate from Bash to ZSH."
chsh -s zsh
rm -rf $HOME/.bash*

echo -e "\t- Add ZSH configuration."
create_symlink $DOTFILES/zsh/zshrc $HOME/.zshrc
create_symlink $DOTFILES/zsh/p10k.zsh $HOME/.p10k.zsh

echo -e "\t- Add Termux configuration."
mkdir -p $HOME/.termux 
create_symlink $DOTFILES/termux/colors.properties $HOME/.termux/colors.properties
cp $DOTFILES/termux/termux.properties $HOME/.termux/termux.properties
create_symlink $DOTFILES/termux/font.ttf $HOME/.termux/font.ttf
create_symlink $DOTFILES/termux/font-italic.ttf $HOME/.termux/font-italic.ttf
create_symlink $DOTFILES/motd $HOME/../usr/etc/motd

echo -e "\t- Add nvim configuration."
mkdir -p $HOME/.config/nvim
create_symlink $DOTFILES/nvim/init.vim $HOME/.config/nvim/init.vim
nvim +"PlugInstall" +qall
nvim +"CocInstall -sync coc-tsserver coc-json coc-eslint coc-html coc-css" +qall
nvim +"CocUpdateSync" +qall

echo -e "\n// Reload settings and setup '~/storage'."
termux-reload-settings
termux-setup-storage

echo -e "\n// Clean-up."
pkg autoclean
pkg clean

clear
echo "/**"
echo " * Done! Now you just have to close and"
echo " * re-open Termux to have the latest modifications."
echo " *"
echo " * Have fun with your new configuration ~"
echo " * - Vexcited"
echo " */"
exit 0

