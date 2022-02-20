#!/bin/bash

func_check_permission() {
  if [ "$EUID" -ne 0 ]
    then echo "run this script on sudo permission"
    exit
  fi
}

func_install_docker() {

  sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

  echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update && apt install docker-ce docker-ce-cli containerd.io -y

  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

  sudo chmod +x /usr/local/bin/docker-compose

  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
}

func_check_permission
func_install_docker
