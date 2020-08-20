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
wy='\033[1;41m' 
h='\033[0m'
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
echo $(echo -e "${r}Welcome to ChinaArch installation!${h}") 
echo $(echo -e "${g}What would you like to do first?${h}") 
echo $(echo -e "${y}1.Divide the disk${h}") 
echo $(echo -e "${b}2.Choose mirror${h}") 
echo $(echo -e "${r}3.Start installation${h}") 
read -p "4.Exit the installation[1,2,3...]:" key 
case $key in
  1)
    clear
    echo "Please choose your tool"
    echo $(echo -e "${r}1.fdisk${h}")
    echo $(echo -e "${g}2.cfdisk${h}") 
    read -p "Please choose[1,2]:"  part
    case $part in 
    1)
      read -p "Which disk you will part?[example:sda]" partdisk
      fdisk /dev/$partdisk
      ;;
    2)
      read -p "Which disk you will part?[example:sda]" partdisk
      cfdisk /dev/$partdisk
      ;;
    esac
  2)
  clear
  PACMANCONF_FILE="/etc/pacman.conf"
  MIRRORLIST_FILE="/etc/pacman.d/mirrorlist"
if [[ ${principal_variable} = 1 ]]; then
    echo ;
    # 检查"/etc/pacman.d/mirrorlist"文件是否存在
    if [ -e ${MIRRORLIST_FILE}  ] ; then      
        # 如果存在
        sh ${MIRROR_SH} || sh -c "$(curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/mirrorlist.sh)" 
    else
        # 如果不存在
        touch ${MIRRORLIST_FILE} && sh ${MIRROR_SH} || sh -c "$(curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/mirrorlist.sh)" 
    fi
    bash ${0}
fi
  3)
  clear
if [[ ${principal_variable} = 2 ]]; then
    echo;
    echo ":: Checking the currently available network."
    sleep 2
    echo -e ":: Ethernet: ${r}${ETHERNET}${h}" 2> $null
    echo -e ":: Wifi:   ${r}${WIFI}${h}" 2> $null 

    READS_B=$(echo -e "${PSG} ${y}Query Network: Ethernet[1] Wifi[2] Exit[3]? ${h}${JHB} ")
    read -p "${READS_B}" wlink
        case $wlink in
            1) 
                echo ":: One moment please............"
                ls /usr/bin/ifconfig &> $null && echo ":: Install net-tools" ||  echo "y" |  pacman -S ifconfig
                ip link set ${ETHERNET} up
                ifconfig ${ETHERNET} up
                systemctl restart dhcpcd  &&  ping -c 3 14.215.177.38 
                sleep 1
                bash ${0}    
            ;;
            2) 
                echo;
                wifi-menu &&  ping  -c 3 14.215.177.38
                sleep 1 
                bash ${0}
                #echo ":: The following WiFi is available: "
                #iwlist ${WIFI} scan | grep "ESSID:"
            ;;
            3) 
                bash ${0}
            ;;
        esac
fi
timedatectl set-ntp true
#选择安装系统的分区，自动格式化并且挂载
                #-------------------分区步骤结束，进入下一个阶段 格式和与挂载分区----------------B------#
                #---BBBB 21----------------root [/]----------------B------#
                echo;
                lsblk | grep -E "sda|sdb|sdc|sdd|sdg|nvme"
                echo;
                READDISK_B=$(echo -e "${y}:: ==>> Choose your root[/] partition: ${g}/dev/sdX[0-9] | sdX[0-9] ${h}${JHB} ")
                read -p "${READDISK_B}"  DISK_LIST_ROOT   #给用户输入接口
                    DISK_NAMEL_B=$(echo "${DISK_LIST_ROOT}" |  cut -d"/" -f3)   #设置输入”/dev/sda” 或 “sda” 都输出为 sda
                    if echo ${DISK_NAMEL_B} | grep -E "^sd[a-z][0-9]$" &> ${null} ; then
                        mkfs.ext4 /dev/${DISK_NAMEL_B}
                        mount /dev/${DISK_NAMEL_B} /mnt
                        ls /sys/firmware/efi/efivars &> ${null} && mkdir -p /mnt/boot/efi || mkdir -p /mnt/boot
                        mkdir /mnt/Archin 2&> /dev/null 
                        cat /tmp/diskName_root > /mnt/diskName_root
                    else
                        clear;
                        echo;
                        echo -e "${r} ==>> Error code [21] Please input: /dev/sdX[0-9] | sdX[0-9] !!! ${h}"
                        exit 21    # 分区时输入错误，退出码。
                    fi
                #---CCCC 22----------------EFI / boot----------------C------#
                echo;
                lsblk | grep -E "sda|sdb|sdc|sdd|sdg|nvme"
                echo;
                READDISK_C=$(echo -e "${y}:: ==>> Choose your EFI / BOOT partition: ${g}/dev/sdX[0-9] | sdX[0-9] ${h}${JHB} ")
                read -p "${READDISK_C}"  DISK_LIST_GRUB   #给用户输入接口
                    DISK_NAMEL_C=$(echo "${DISK_LIST_GRUB}" |  cut -d"/" -f3)   #设置输入”/dev/sda” 或 “sda” 都输出为 sda
                    if echo ${DISK_NAMEL_C} | grep -E "^sd[a-z][0-9]$" &> ${null} ; then
                        mkfs.vfat /dev/${DISK_NAMEL_C}
                        ls /sys/firmware/efi/efivars &> ${null} && mount /dev/${DISK_NAMEL_C} /mnt/boot/efi || mount /dev/${DISK_NAMEL_C} /mnt/boot
                    else
                        clear;
                        echo;
                        echo -e "${r} ==>> Error code [22] Please input: /dev/sdX[0-9] | sdX[0-9] !!! ${h}"
                        exit 22    # 分区时输入错误，退出码。
                    fi
                #---DDDD 23-----------SWAP file 虚拟文件(类似与win里的虚拟文件) 对于swap分区我更推荐这个，后期灵活更变---------------#
                echo
                lsblk | grep -E "sda|sdb|sdc|sdd|sdg|nvme"
                echo;
                READDISK_D=$(echo -e "${y}:: ==>> Please select the size of swapfile: ${g}[example:512M-4G ~] ${h}${JHB} ")
                read -p "${READDISK_D}"  DISK_LIST_SWAP     #给用户输入接口
                    DISK_NAMEL_D=$(echo "${DISK_LIST_SWAP}" |  cut -d"/" -f3)   #设置输入”/dev/sda” 或 “sda” 都输出为 sda
                    if echo ${DISK_NAMEL_D} | grep -E "^[0-9]*[A-Z]$" &> ${null} ; then
                        echo -e ""
                        fallocate -l ${DISK_NAMEL_D} /mnt/swapfile
                        chmod 600 /mnt/swapfile
                        mkswap /mnt/swapfile
                        swapon /mnt/swapfile
                    else
                        clear;
                        echo;
                        echo -e "${r} ==>> Error code [23] Please input size: [example:512M-4G ~] !!! ${h}"
                        exit 23    # 分区时输入错误，退出码。
                    fi
            echo -e "${wg} ::==>> Partition complete. ${h}"
            bash ${0} 
        fi 
        # list2========== 安装及配置系统文件 ==========222222222222222
    if [[ ${tasks} == 2 ]];then
            echo -e "${wg}Update the system clock.${h}"  #更新系统时间
            timedatectl set-ntp true
            sleep 4
            echo;
            echo -e "${PSG} ${g}Install the base packages.${h}"   #安装基本系统
            echo;
                pacstrap /mnt base base-devel linux  # 第一部分
                pacstrap /mnt linux-firmware linux-headers ntfs-3g networkmanager net-tools dhcpcd vim   # 第二部分 分开安装，避免可不必要的错误！
            echo;
	        sleep 3
            echo -e "${PSG}  ${g}Configure Fstab File.${h}" #配置Fstab文件
	            genfstab -U /mnt >> /mnt/etc/fstab && cat /tmp/diskName_root > /mnt/diskName_root
                echo;
            sleep 2
            clear;
            echo;
            echo;
            echo -e "${wg}#======================================================#${h}"
            echo -e "${wg}#::  System components installation completed.         #${h}"            
            echo -e "${wg}#::  Entering chroot mode.                             #${h}"
            echo -e "${wg}#::  Execute in 3 seconds.                             #${h}"
            echo -e "${wg}#::  Later operations are oriented to the new system.  #${h}"
            echo -e "${wg}#======================================================#${h}"
            sleep 3
            echo    # Chroot到新系统中完成基础配置，第一步配置
            rm -rf /mnt/etc/pacman.conf 2&>${null}
            rm -rf /mnt/etc/pacman.d/mirrorlist 2&>${null}
            cp -rf /etc/pacman.conf /mnt/etc/pacman.conf.bak 2&>${null}
            cp -rf /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist.bak 2&>${null}
            mkdir /mnt/Archin 2&> /dev/null

            cat $0 > /mnt/install2.sh  && chmod +x /mnt/install2.sh
            cp -rf /etc/pacman.conf.bak /mnt/etc/pacman.conf 2&>${null}
            cp -rf /etc/pacman.d/mirrorlist.bak /mnt/etc/pacman.d/mirrorlist 2&>${null}
            arch-chroot /mnt /bin/bash /install2.sh
esac