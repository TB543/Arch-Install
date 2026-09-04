#!/bin/bash

# this script will automatically sync config files with the github repo
# must be run from the Arch-Install directory
cp /etc/ly/config.ini config/ly.ini
cp ~/.config/hypr/hyprland.lua config/hyprland.lua

# pushes changes to the github repo
git add .
read -p "Commit message: " msg
git commit -m "$msg"
git push
