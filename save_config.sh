#!/bin/bash

# this script will automatically sync config files with the github repo
# must be run from the Arch-Install directory
cp ~/.config/qtile/config.py config/qtile.py
cp /etc/ly/config.ini config/ly.ini
cp ~/.config/picom/picom.conf config/picom.conf

# pushes changes to the github repo
git add .
git commit -m "update config files"
git push
