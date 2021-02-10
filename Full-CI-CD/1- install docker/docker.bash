#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "run this script on sudo permission"
  exit
fi

# Uninstall old versions if exist
apt-get remove docker docker-engine docker.io containerd runc -y

apt autoremove

apt-get update

apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

apt-get update

apt-get install docker-ce docker-ce-cli containerd.io -y
