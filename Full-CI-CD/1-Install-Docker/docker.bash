#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "run this script on sudo permission"
  exit
fi

# Uninstall old versions if exist
sudo apt-get remove docker docker-engine docker.io containerd runc -y

sudo apt autoremove -y

sudo apt-get update -y

sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo sed -i 's/debian/ubuntu/g' /etc/apt/sources.list.d/docker.list

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io -y
