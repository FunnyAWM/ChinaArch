#! /bin/bash
userexist='cat /etc/passwd | grep 1000'
passwordexist='echo $?'
clear
if [[ $userexist =~ "1000" ]] ;then
  read -p "Please enter your current user name." username
  echo "Please set a password for $username."
  passwd $username
  elif [[ $userexist =~ "" ]] ;then
  read -p "Please enter your new user name." username
  adduser $username -h
  echo "Please set a password for $username."
  passwd $username
  echo "Changing root password"
  passwd
fi
if [[ $passwordexist =~ "password unchanged"]] ;then
  echo "Password change failed."
  echo "Please reset your password."
  bash adduser.sh
fi