#!/bin/bash


# gets user input for install steps
clear
read -rsp "Enter the user credentials encryption key: " key
clear
read -rp "Edit config? [y/n]: " cnf
clear
lsblk -f
read -rp "Enter the partition containing windows for dual boot or hit enter to ignore dual boot: " drive

# install arch
if [ "$cnf" = "y" ]; then
    archinstall --config-url https://raw.githubusercontent.com/TB543/Arch-Install/refs/heads/main/config/user_configuration.json \
        --creds-url https://raw.githubusercontent.com/TB543/Arch-Install/refs/heads/main/config/user_credentials.json \
        --creds-decryption-key "$key"
else
    archinstall --config-url https://raw.githubusercontent.com/TB543/Arch-Install/refs/heads/main/config/user_configuration.json \
        --creds-url https://raw.githubusercontent.com/TB543/Arch-Install/refs/heads/main/config/user_credentials.json \
        --creds-decryption-key "$key" \
        --silent
fi

# sets up user config
arch-chroot /mnt /bin/bash -s -- "$drive" <<'EOF' 
USER1000=$(getent passwd 1000 | cut -d: -f1)
echo "$USER1000 ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

# runs post install script as user
runuser -u 1000 -- bash -c '
cd ~
git clone https://github.com/TB543/Arch-Install
cd Arch-Install
chmod +x postinstall.sh
chmod +x save_config.sh
./postinstall.sh "$1"
' -- "$1"

# reboots into new OS
EOF
arch=$(sudo efibootmgr | grep 'UEFI OS' | cut -c5-8)
sudo efibootmgr -n "$arch"
order=$(sudo efibootmgr | grep '^BootOrder:' | cut -d' ' -f2)
sudo efibootmgr -o "$arch,$(echo "$order" | sed "s/$arch,//;s/,$arch//")"
sleep 10
reboot
