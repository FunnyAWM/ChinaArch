#! /bin/bash
#定义文文字颜色
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
wy='\033[1;41m' 
h='\033[0m'
#本地化
clear
rm /etc/locale.gen
echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
rm /etc/locale.conf
echo "LANG=zh_CN.UTF8" >> /etc/locale.conf
echo "LANG=en_US.UTF8" >> /etc/locale.conf
#安装桌面
clear
pacman -S xorg
echo "Please choose your GPU"
echo $(echo -e "${b}1.Intel${h}") 
echo $(echo -e "${r}2.AMD${h}") 
echo $(echo -e "${r}3.ATI${h}") 
echo $(echo -e "${g}4.NVDIA${h}") 
read -p "If you have two GPUs,then entertwo numbers(ATI and NVIDIA,ATI and AMD could not appear in the same time):"  GPU
case $GPU in
  1)
    pacman -S xf86-video-intel
    ;;
  2)
    pacman -S xf86-video-amdgpu
    ;;
  3)
    pacman -S xf86-video-ati
    ;;
  4)
    pacman -S xf86-video-noveau
    ;;
  12)
    pacman -S xf86-video-intel xf86-video-amdgpu
    ;;
  13)
    pacman -S xf86-video-intel xf86-video-ati
    ;;
  14)
    pacman -S xf86-video-intel xf86-video-noveau
    ;;
  24)
    pacman -S xf86-video-amdgpu xf86-video-noveau
    ;;
 esac
clear
echo "Which desktop environment do you want to install?"
echo "1.KDE-full"
echo "2.KDE-minimal"
echo "3.GNOME"
echo "4.Xfce"
echo "5.MATE"
echo "6.LXDE"
read -p "7.i3wm"  desktop
case $desktop in
  1)
    pacman -S plasma kde-applications sddm
    systemctl enable sddm
    ;;
  2)
    pacman -S plasma dolphinn okular kate konsole
    systemctl enable sddm
    ;;
  3)
    pacman -S gnome gdm
    systemctl enable gdm
    ;;
  4)
    pacman -S xfce lightdm
    systemctl enable lightdm
    ;;
  5)
    pacman -S mate lightdm
    systemctl enable lightdm
    ;;
  6)
    pacman -S lxde lightdm
    systemctl enable lightdm
    ;;
  7)
    pacman -S i3wm lightdm
    systemctl enable lightdm
    ;;
 esac
echo "Which Internet browser do you want to choose?"
echo "1.Firefox"
echo "2.Google Chrome"
read -p "3.Chromium" browser
case $browser in
  1)
    pacman -S firefox
    ;;
  2)
    pacman -S google-chrome
    ;;
  3)
    pacman -S chromium
    ;;
 esac
echo "Which office suite do you want to use?"
echo "1.Libreoffice"
echo "2.WPS"
read -p "3.No office suite" office
case $office in
  1)
    pacman -S libreoffice libreoffice-still-zh-cn
    ;;
  2)
    pacman -S wps-office-cn wps-office-mime-cn wps-office-mui-zh-cn
    ;;
 esac
pacman -S netease-cloud-music wine-wechat
echo "Witch way do you want to boot up your computer?"
echo "1.Legacy"
read -p "2.UEFI" boot
case $boot in
  1)
    grub-install --target=i386-pc /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg
    ;;
  2)
    read -p "Please select the EFI partition(example:sda1)" esp
    grub-install --target=x86_64-efi --efi-directory=/dev/$esp --bootloader-id=ChinaArch
    ;;
 esac
rm -f /etc/systemd/system/install.service
echo "Now please enjoy ChinaArch.Remember to pull out your USB drive first."
echo "Press any key to exit the installation.to reboot,please type in'reboot'"
echo "ChinaArch by FunnyAWM."
echo "QQ:1142978300"
read -p "Press any key to continue..."
exit