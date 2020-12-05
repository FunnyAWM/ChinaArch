#! /bin/bash
clear
read -p "Which partiton will you use?[example:sda1]" partadd
clear
read -p "Do you want to format it?[y/n]" formatc
case $formatc in
y)
  mkfs.ext4 /dev/$partadd
  clear
  ;;
n)
  clear
  ;;
esac
read -p "Please select where to mount.[example:/home]" partdir
mkdir /mnt/$partdir
mount /dev/$partadd /mnt/$partdir
clear
read -p "Do you need any additional partition?[y/n]" part
case $part in
y)
  bash parto.sh
  ;;
n)
  clear
  ;;
esac