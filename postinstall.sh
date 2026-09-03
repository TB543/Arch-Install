#!/bin/bash


# sets up dual boot
read -rp "Setup dual boot for windows? [y/n]: " answer
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

# user config
git config --global user.email "tbarron543@gmail.com"
git config --global user.name "TB543"
sudo cp config/ly.ini /etc/ly/config.ini
sudo rm /usr/share/wayland-sessions/hyprland-uwsm.desktop

# installs package manager for desktop apps and installs apps
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
sudo rm -rf yay
yay -S --noconfirm google-chrome visual-studio-code-bin spotify
