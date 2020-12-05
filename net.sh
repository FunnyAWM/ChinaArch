#! /bin/bash
STABLE='echo $?'
echo "This script requires Internet connection."
echo "Please choose your way to connect to Internet."
echo "1.WiFi."
echo "2.Ethernet."
read -p "[1,2]" net
case $net in
1)
  iwctl device list
  read -p "Which device will you use?"  device
  iwctl station $device scan
  iwctl station $device get-network
  read -p "Which network will you connect?" SSID
  read -p "Does it requires a password?[Y/N]" passphrasec
  case $passphrasec in
  y)
    read -p "Password:" passphrase
	iwctl --passphrase $passphrase station $device connect $SSID
	;;
  n)
    iwctl $device connect $SSID
	;;
  esac
  ping -c 3 baidu.com
  if [[STABLE = 0]]; then
  clear
  else
  echo "This WiFi connection is unstable!"
  echo "IT MAY CAUSE PROBLEMS!"
  echo "Are you going to continue?"
  read -p "[y/N]" confirm
  if [[$confirm = 0]];then
  set $confirm=n
  case $confirm in
	y)
	  clear
	  ;;
	n)
	  bash net.sh
	  ;;
  esac
  fi
  ;;
2)
  dhcpcd
  ping -c 3 baidu.com
  ;;
esac