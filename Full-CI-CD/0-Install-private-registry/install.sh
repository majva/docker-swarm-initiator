#!/bin/bash

: ' write refrences for more searching
    refrence: https://phoenixnap.com/kb/set-up-a-private-docker-registry
'

if [ "$EUID" -ne 0 ]
  then echo -e "\033[31mRun this script on sudo permission ..."
  exit
fi

mkdir /root/registry && mkdir /root/registry/nginx && mkdir /root/registry/auth
mkdir -p /root/nginx/conf.d && mkdir -p /root/nginx/ssl
mv ./registry.conf /root/registry/nginx/conf.d

echo "\nRun this script on sudo permission ... \n"

mkdir /root/create-ssl && mkdir /root/create-ssl/keys
mkdir /root/create-ssl/certs

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /root/create-ssl/keys/registry.key -out /root/create-ssl/certs/registry.crt

openssl dhparam -out /root/create-ssl/certs/registry.pem 2048
openssl dhparam -out /root/create-ssl/keys/registrykey.pem 2048

cp /root/create-ssl/certs/registry.pem /root/nginx/ssl/
cp /root/create-ssl/keys/registrykey.pem /root/nginx/ssl/


echo "[+] Request a new password file named {registry.passwd} for your user"

htpasswd -Bc registry.passwd hacktor

mkdir ./tmp
touch ./tmp/rootCA

openssl x509 -in rootCA.pem -inform PEM -out ./tmp/rootCA.crt

mkdir -p /etc/docker/certs.d/registry.hacktor.com/

cp ./tmp/rootCA.crt /etc/docker/certs.d/hacktor.com/

mkdir -p /usr/share/ca-certificates/extra/
cp ./tmp/rootCA.crt /usr/share/ca-certificates/extra/

dpkg-reconfigure ca-certificates

systemctl restart docker

echo "[+] Start building image ..."

docker-compose up -d
