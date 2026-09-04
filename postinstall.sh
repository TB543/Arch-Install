#!/bin/bash


# sets up dual boot
if [ -n "$1" ]; then
    sudo pacman -S --noconfirm os-prober
    sudo sed -i 's/^#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
    mkdir mnt
    sudo mount /dev/"$1" mnt
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    sudo umount /dev/"$1"
    rmdir mnt
fi

# user config
sudo rm /usr/share/wayland-sessions/hyprland-uwsm.desktop
git config --global user.email "tbarron543@gmail.com"
git config --global user.name "TB543"
sudo cp config/ly.ini /etc/ly/config.ini
cp config/hyprland.lua ~/.config/hypr/hyprland.lua

# installs package manager for desktop apps and installs apps
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
sudo rm -rf yay
yay -S --noconfirm google-chrome visual-studio-code-bin spotify
