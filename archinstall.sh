#!/bin/bash


# gets user input for install steps
read -rsp "Enter the user credentials encryption key: " key
read -rp "Edit config? [y/n]: " ans

if [ "$ans" = "y" ]; then
    archinstall --config-url https://raw.githubusercontent.com/TB543/Arch-Install/refs/heads/main/config/user_configuration.json \
        --creds-url https://raw.githubusercontent.com/TB543/Arch-Install/refs/heads/main/config/user_credentials.json \
        --creds-decryption-key "$key" \
else
    archinstall --config-url https://raw.githubusercontent.com/TB543/Arch-Install/refs/heads/main/config/user_configuration.json \
        --creds-url https://raw.githubusercontent.com/TB543/Arch-Install/refs/heads/main/config/user_credentials.json \
        --creds-decryption-key "$key" \
        --silent
fi

# sets up user config
arch-chroot /mnt /bin/bash <<'EOF' 
USER1000=$(getent passwd 1000 | cut -d: -f1)
echo "$USER1000 ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

# runs post install script as user
runuser -u 1000 -- bash -c '
cd ~
git clone https://github.com/TB543/Arch-Install
cd Arch-Install
chmod +x postinstall.sh
chmod +x save_config.sh
./postinstall.sh
'

# reboots into new OS
EOF
reboot
