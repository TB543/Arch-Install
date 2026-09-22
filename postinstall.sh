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

# mounts additional drives
sudo mkdir -p /mnt/shared
echo 'UUID=484D-B7CA /mnt/shared exfat uid=1000,gid=1000,umask=022,nofail 0 0' | sudo tee -a /etc/fstab
sudo mount -a

# user config
sudo systemctl enable NetworkManager
systemctl --user enable ydotool
sudo usermod -aG input $(whoami)
sudo rm /usr/share/wayland-sessions/hyprland-uwsm.desktop
git config --global user.email "tbarron543@gmail.com"
git config --global user.name "TB543"
sudo cp config/ly.ini /etc/ly/config.ini
mkdir -p ~/.config/hypr
mkdir -p ~/.config/udiskie
cp config/hyprland.lua ~/.config/hypr/hyprland.lua
cp -r config/caelestia ~/.config/caelestia
cp -r config/udiskie.yml ~/.config/udiskie/config.yml

# sets up scripts and services
chmod +x assets/auto-unzip.sh
sudo cp services/auto-unzip.service ~/.config/systemd/user/auto-unzip.service
systemctl --user enable auto-unzip.service
mkdir ~/Downloads

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
