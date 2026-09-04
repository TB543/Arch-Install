#!/bin/bash

# this script will automatically sync config files with the github repo
# must be run from the Arch-Install directory

# removes old config
rm -rf config/hypr

# copies new config
cp /etc/ly/config.ini config/ly.ini
cp -r ~/.config/hypr config/hypr
cp ~/.config/quickshell/shell.qml config/quickshell.qml

# pushes changes to the github repo
git add .
read -p "Commit message: " msg
git commit -m "$msg"
git push
