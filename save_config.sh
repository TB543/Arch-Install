#!/bin/bash

# this script will automatically sync config files with the github repo
# must be run from the Arch-Install directory

# copies new config
cp /etc/ly/config.ini config/ly.ini
cp ~/.config/hypr/hyprland.lua config/hyprland.lua
rm -r config/caelestia
cp -r ~/.config/caelestia config/caelestia
cp -r ~/.config/udiskie/config.yml config/udiskie.yml

# pushes changes to the github repo
git add .
read -p "Commit message: " msg
git commit -m "$msg"
git push
