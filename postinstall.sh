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
sudo systemctl enable NetworkManager
systemctl --user enable ydotool
sudo usermod -aG input $(whoami)
sudo rm /usr/share/wayland-sessions/hyprland-uwsm.desktop
git config --global user.email "tbarron543@gmail.com"
git config --global user.name "TB543"
sudo cp config/ly.ini /etc/ly/config.ini
mkdir -p ~/.config/hypr
cp config/hyprland.lua ~/.config/hypr/hyprland.lua

# caelestria (quickshell config) dependencies
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ..
sudo rm -rf paru
paru -S --noconfirm caelestia-cli quickshell-git ttf-rubik-vf qt6-m3shapes-git libcava

# caelestria (quickshell config)
mkdir -p ~/.config/quickshell
cd ~/.config/quickshell
git clone https://github.com/caelestia-dots/shell.git caelestia
cd caelestia
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/ -DINSTALL_QSCONFDIR="$HOME/.config/quickshell/caelestia"
cmake --build build
sudo cmake --install build
sudo chown -R $USER ~/.config/quickshell/caelestia

# yay (desktop apps)
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
sudo rm -rf yay
yay -S --noconfirm google-chrome visual-studio-code-bin spotify
