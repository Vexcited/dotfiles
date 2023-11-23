#!/usr/bin/env bash

# This file is a global setup script. Here,
# we'll determine the type of configuration to use
# and run the bash script linked to it.
#
# > github.com/vexcited/dotfiles
clear # Let's get clean before showing any text.

if [ ! -z "$CODESPACES" ] && [ "$CODESPACES" = "true" ]
then
  echo "check: codespace environment detected. running 'setup-codespace.sh'"
  
  chmod +x ./setup-codespace.sh
  ./setup-codespace.sh
  exit 0
elif [ ! -z "$TERMUX_VERSION" ]
then
  echo "check: termux environment detected. running 'setup-termux.sh'"
  
  chmod +x ./setup-termux.sh
  ./setup-termux.sh
  exit 0
else
  echo "check: nothing compatible with your env was detected."
  echo "try again later."
  echo ""
  echo "if your environment was arch-linux, please run it manually:"
  echo "\t- arch-linux: ./setup-arch-linux.sh"
  exit 1 # 1 : nothing was detected.
fi


