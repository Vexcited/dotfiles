#!/bin/sh

echo "Pull latest configuration files..."
git pull

echo "Update and install packages..."
pkg upgrade -y
pkg install nano wget curl gh nodejs -y

echo "Setup git..."
git config --global user.name "Mikkel RINGAUD"
git config --global user.email "mikkel@milescode.dev"
gh auth login -p https -w

echo "Symlink configuration..."
rm -rf ~/.bashrc && ln -s ~/dotfiles/termux/.bashrc ~/.bashrc
rm -rf ~/.termux && ln -s ~/dotfiles/termux/.termux ~/.termux

echo "Load..."
termux-reload-settings
termux-setup-storage

echo "Clean-up..."
pkg clean

echo "Done !"
