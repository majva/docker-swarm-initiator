#!/bin/bash

: ' write refrences for more searching
    refrence: https://phoenixnap.com/kb/set-up-a-private-docker-registry
'

if [ "$EUID" -ne 0 ]
  then echo "run this script on sudo permission"
  exit
fi

source .bashrc

# step 1 - create working directory

mkdir -p /root/docker/registry

mkdir -p $/root/docker/registry/nginx && mkdir $/root/docker/registry/auth
mkdir -p $/root/docker/registry/nginx/conf.d 
mkdir -p $/root/docker/registry/nginx/ssl
mkdir -p $/root/docker/registry/nginx/certs.d

cp registry.conf $/root/docker/registry/nginx/conf.d

apt install openssl -y

openssl req -newkey rsa:4096 -nodes -sha256 -keyout $/root/docker/registry/nginx/certs.d/domain.key -x509 -days 365 -out $/root/docker/registry/nginx/certs.d/domain.crt

openssl x509 -in $/root/docker/registry/nginx/ssl/fullchain.pem -inform PEM -out $/root/docker/registry/nginx/certs.d/domain.crt
openssl x509 -in $/root/docker/registry/nginx/ssl/privkey.pem -inform PEM -out $/root/docker/registry/nginx/certs.d/domain.key

htpasswd -Bc $/root/docker/registry/auth/registry.passwd example

mkdir -p $/root/docker/registry/ca

openssl x509 -in $/root/docker/registry/ca/rootCA.pem -inform PEM -out $/root/docker/registry/ca/rootCA.crt

mkdir -p /etc/docker/certs.d

cp $/root/docker/registry/ca/rootCA.crt /etc/docker/certs.d/$REGISTRY_HOST

mkdir -p /usr/share/ca-certificates/extra/

cp $/root/docker/registry/ca/rootCA.crt /usr/share/ca-certificates/extra/

dpkg-reconfigure ca-certificates

systemctl restart docker

docker-compose up -d
