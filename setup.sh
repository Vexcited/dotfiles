#!/usr/bin/env bash

# This file is a global setup script. Here,
# we'll determine the type of configuration to use
# and run the bash script linked to it.
#
# > github.com/vexcited/dotfiles
clear

if [ ! -z "$TERMUX_VERSION" ]
then
  echo "check: termux environment detected. running 'setup-termux.sh'"
  
  chmod +x ./setup-termux.sh
  ./setup-termux.sh
  exit 0
else
  echo "check: nothing compatible with your env was detected."
  echo "try again later."
  exit 1 # 1 : nothing was detected.
fi

