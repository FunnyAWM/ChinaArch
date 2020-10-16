#!/bin/bash
#定义文字颜色
r='\033[1;31m'	#---红
g='\033[1;32m'	#---绿
y='\033[1;33m'	#---黄
b='\033[1;36m'	#---蓝
w='\033[1;37m'	#---白
rw='\033[1;41m'    #--红白
wg='\033[1;42m'    #--白绿
ws='\033[1;43m'    #--白褐
wb='\033[1;44m'    #--白蓝
wq='\033[1;45m'    #--白紫
wa='\033[1;46m'    #--白青
wh='\033[1;46m'    #--白灰
h='\033[0m'		   #---后缀
bx='\033[1;4;36m'  #---蓝 下划线
# 交互 蓝
JHB=$(echo -e "${b}-=>${h}")
# 交互 红
JHR=$(echo -e "${r}-=>${h}")
# 交互 绿
JHG=$(echo -e "${g}-=>${h}")
# 交互 黄
JHY=$(echo -e "${y}-=>${h}")
#选择操作
clear
echo $(echo -e "${r}Welcome to Arch Linux installation!${h}") 
echo $(echo -e "${g}What would you like to do first?${h}") 
echo $(echo -e "${y}1.Part the disk${h}") 
echo $(echo -e "${b}2.Start installation.${h}") 
echo $(echo -e "${r}3.About${h}") 
read -p "4.Exit the installation[1,2,3...]:" key
case $key in
  1)
    clear
    echo "Please choose your tool"
    echo $(echo -e "${r}1.fdisk${h}")
    echo $(echo -e "${g}2.cfdisk${h}") 
    echo $(echo -e "${g}2.cgdisk${h}") 
    read -p "Please choose[1,2]:"  part
    case $part in 
    1)
      clear
      lsblk
      read -p "Which disk you will part?[example:sda]" partdisk
      fdisk /dev/$partdisk
      ;;
    2)
      clear
      lsblk
      read -p "Which disk you will part?[example:sda]" partdisk
      cfdisk /dev/$partdisk
      ;;
    3)
      clear
      lsblk
      read -p "Which disk you will part?[example:sda]" partdisk
      cgdisk /dev/$partdisk
      ;;
    esac
    ;;
  2)
    clear
    echo "Please choose your tool"
    echo $(echo -e "${r}1.fdisk${h}")
    echo $(echo -e "${g}2.cfdisk${h}") 
    echo $(echo -e "${g}2.cgdisk${h}") 
    read -p "Please choose[1,2]:"  part
    case $part in 
    1)
      clear
      lsblk
      read -p "Which disk you will part?[example:sda]" partdisk
      fdisk /dev/$partdisk
      ;;
    2)
      clear
      lsblk
      read -p "Which disk you will part?[example:sda]" partdisk
      cfdisk /dev/$partdisk
      ;;
    3)
      clear
      lsblk
      read -p "Which disk you will part?[example:sda]" partdisk
      cgdisk /dev/$partdisk
      ;;
    esac
    echo "This script requires Internet connection."
    echo "Please choose your way to connect to Internet."
    echo "1.WiFi."
    echo "2.Ethernet."
    read -p "[1,2]" net
    case $net in
    1)
      wifi-menu
      ping -c 3 baidu.com
      ;;
    2)
      dhcpcd
      ping -c 3 baidu.com
      ;;
    esac
    timedatectl set-ntp true
    clear
    read -p "Which disk will you use for root(/)partition?[example:sda1]" partroot
    mkfs.ext4 /dev/$partroot
    mount /dev/partroot /mnt
    clear
    read -p "Do you need any additional partition?[y/n]" part
    case $part in 
    y)
      read -p "Which partiton will you use?[example:sda1]" partadd
      mkfs.ext4 /dev/$partadd
      read -p "Please select where to mount.[example:/home]" partdir
      mkdir /mnt/$partdir
      mount /dev/$partadd /mnt/$partdir
      read -p "Do you need any additional partition?[y/n]" part
      ;;
    n)
      clear
      ;;
    esac
  clear
  read -p "Do you need ESP partition?[y/n]" partespc
  case $partespc in
    y)
      read -p "Please select ESP partition[example:sda1]" partesp
      mkfs.vfat /dev/$partesp
	    mkdir /mnt/boot
	    mkdir /mnt/boot/EFI
	    mount /dev/$partesp /mnt/boot/EFI
	    ;;
    n)
	    clear
	    ;;
  esac
  clear
	read -p "Do you need a swap partition?[y/n]" swapc
	case $swapc in
	y)
	  echo "Which format will you use?"
	  echo "1.By file."
	  echo "2.By partition."
	  read -p "[1,2]" swapc2
	  case $swapc2 in 
	  1)
	   read -p "Please enter the size.(example:4G)" swap
	   fallocate -l $swap /swapfile
	   chmod 600 /swapfile
	   mkswap /swapfile
	   swapon /swapfile
	   ;;
	  2)
	   read -p "Which partition will you use?(example:sda1)" swap
	   mkswap /dev/$swap
	   swapon /dev/$swap
	   ;;
	  esac
    ;;
	 n)
	 clear
	 ;;
	esac
	echo "How do you gengrate your fstab file?"
	echo "1.By UUID."
	echo "2.By Label."
	read -p "[1,2]" fstab
	case $fstab in
	 1)
	  genfstab -U /mnt >> /mnt/etc/fstab
	  ;;
	 2)
	  genfstab /mnt >> /mnt/etc/fstab
	  ;;
	esac
	clear
	read -p "Do you want to install base packages with AUR supportment?[y/n]" base
	case $base in
	y)
	  clear
	  echo "Installing base packages with AUR supportment."
	  pacstrap -i /mnt base base-devel nano grub linux linux-firmware archlinuxcn-keyring
	  clear
    echo "The first stage of installation has complete."
	  echo "Entering second stage in 3 secs."
	  break in 3
    ;;
	n)
	  clear
	  echo "Installing base packages."
	  pacstrap -i /mnt base nano grub linux linux-firmware archlinucn-keyring
      clear
	  echo "The first stage of installation has complete."
	  echo "Entering second stage in 3 secs."
	  break in 3
	 ;;
	esac
  ;;
  3)
  clear
  echo "Arch Linux install script by FunnyAWM."
  echo "QQ:1142978300."
  read -p "Press any key to exit..."
  clear
  bash install.sh
esac