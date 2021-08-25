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

# step 1 - create working directory

initialize_server() {

  mkdir -p /root/docker/registry
  docker_registry_src = /root/docker/registry

  mkdir -p $docker_registry_src/nginx && mkdir $docker_registry_src/auth
  mkdir -p $docker_registry_src/nginx/conf.d 
  mkdir -p $docker_registry_src/nginx/ssl
  mkdir -p $docker_registry_src/nginx/certs.d

  cp registry.conf $docker_registry_src/nginx/conf.d

  apt install openssl -y
  
  openssl req -newkey rsa:4096 -nodes -sha256 -keyout $docker_registry_src/nginx/certs.d/domain.key -x509 -days 365 -out $docker_registry_src/nginx/certs.d/domain.crt

  openssl x509 -in $docker_registry_src/nginx/ssl/fullchain.pem -inform PEM -out $docker_registry_src/nginx/certs.d/domain.crt
  openssl x509 -in $docker_registry_src/nginx/ssl/privkey.pem -inform PEM -out $docker_registry_src/nginx/certs.d/domain.key

  htpasswd -Bc $docker_registry_src/auth/registry.passwd example

  mkdir -p $docker_registry_src/ca

  openssl x509 -in $docker_registry_src/ca/rootCA.pem -inform PEM -out $docker_registry_src/ca/rootCA.crt

  mkdir -p /etc/docker/certs.d

  cp $docker_registry_src/ca/rootCA.crt /etc/docker/certs.d/registry.aranuma.com

  mkdir -p /usr/share/ca-certificates/extra/

  cp $docker_registry_src/ca/rootCA.crt /usr/share/ca-certificates/extra/

  dpkg-reconfigure ca-certificates

  systemctl restart docker
}

check_root_access
initialize_server

docker-compose up -d
