#!/bin/bash

# this  file should be run after installing a minimal arch build
# must be run in the Arch-Install directory as default user

# ensures sudo does not need password when logged in
echo "$(whoami) ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

# sets up dual boot
read -p "Setup dual boot for windows? [y/n]" answer
if [ "$answer" = "y" ]; then
    sudo pacman -S --noconfirm os-prober
    sudo sed -i 's/^#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
    clear
    lsblk -f
    read -p "Enter the partition containing windows:" drive
    mkdir mnt
    sudo mount /dev/$drive mnt
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    sudo umount /dev/$drive
    rmdir mnt
fi

# creates config files
sudo cp config/ly.ini /etc/ly/config.ini

# removes unused desktop env
sudo rm /usr/share/wayland-sessions/hyprland-uwsm.desktop

# installs package manager for desktop apps
sudo pacman -S --noconfirm base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
sudo rm -rf yay

# installs desktop apps
yay -S --noconfirm google-chrome visual-studio-code-bin spotify

# reboots system
sudo reboot
