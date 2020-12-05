#! /bin/bash
pacman -S networkmanager nm-applet --noconfirm
systemctl disable netctl
systemctl enable NetworkManager
echo "NetworkManager enabled."
break in 2