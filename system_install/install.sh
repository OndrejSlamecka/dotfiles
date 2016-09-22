#/bin/sh
if [ -z "$username" ]; then
    echo 'Set the `username` variable'
    exit 1
fi

curl -O https://raw.githubusercontent.com/OndrejSlamecka/dotfiles/master/system_install/base.sh
sh base.sh

# Now to the user part
# First let user to sudo some commands without asking for password
allow_cmds="$username ALL = NOPASSWD: `which pacman`, `which sed`, `which pacman-key`, `which ln`"
echo "$allow_cmds" >> /etc/sudoers

# Download and run the install script
curl -O https://raw.githubusercontent.com/OndrejSlamecka/dotfiles/master/system_install/user.sh
cp user.sh /home/$username/user.sh # TODO: mv
sudo -i -u "$username" username="$username" sh user.sh

# Revoke the privileges for sudo-ing without password
sed -i "#$allow_cmds#d"

# Clean up install files
rm base.sh /home/$username/user.sh

# WiFi device advice
echo """If this is a wifi only device you may want to

    pacman -S dialog wpa_supplicant wireless_tools
    wifi-menu # connect and create profile
    netctl enable <profile name>
"""

# Boot loader reminder
echo "Don't forget to install boot loader!"
