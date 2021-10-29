#!/bin/bash

: ' write refrences for more searching
    refrence: https://phoenixnap.com/kb/set-up-a-private-docker-registry
'

check_root_access() {
  if [ "$EUID" -ne 0 ]
    then echo -e "\033[31mRun this script on sudo permission ..."
    exit
  fi
}

initialize_server() {
  mkdir -p /root/docker_data/certs

  apt install openssl -y

  openssl genrsa -out /root/docker_data/certs/domain.key

  openssl req -new -key /root/docker_data/certs/domain.key -out /root/docker_data/certs/request.csr

  openssl x509 -req -days 365 -in /root/docker_data/certs/request.csr -signkey /root/docker_data/certs/domain.key -out /root/docker_data/certs/domain.key


  # openssl req -newkey rsa:4096 -nodes -sha256 -keyout /root/docker_data/certs/domain.key -x509 -days 365 -out /root/docker_data/certs/domain.crt

  mkdir -p /root/docker_data/image  

}

check_root_access
initialize_server

docker-compose up -d