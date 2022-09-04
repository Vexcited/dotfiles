#!/bin/sh
#
# This file is a global setup script. Here,
# we'll determine the type of configuration to use
# and run the bash script linked to it.
#
# Made by Vexcited
# @ github.com/vexcited/dotfiles
clear

if [ "$CODESPACES" = "true" ]
then
  echo "check: codespace environment detected. running 'setup-codespace.sh'..."
  
  chmod +x ./setup-codespace.sh
  ./setup-codespace.sh
else
  echo "check: nothing CURRENTLY compatible with your os was detected."
  echo "try again later."
  echo ""
  echo "if your os was arch-linux or termux, please run them manually:"
  echo "\t- termux: ./setup-termux.sh"
  echo "\t- arch-linux: ./setup-arch-linux.sh"
fi

