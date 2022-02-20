#!/bin/bash

func_check_permission() {
  if [ "$EUID" -ne 0 ]
    then echo "run this script on sudo permission"
    exit
  fi
}

func_create_certs() {

    apt install apache2-utils -y

    # certificate location
    CERT_LOCATION=./conf/certs

    # generate key and cert
    openssl req -x509 -nodes -newkey \
    rsa:4096 -days 365 \
    -keyout $CERT_LOCATION/key.pem \
    -subj "/C=IR/ST=Iran/L=Tehran/O=hacktor/OU=IT/CN=hacktor.co/emailAddress=topcodermc@gmail.com" \
    -out $CERT_LOCATION/cert.pem

    # cehck certificate
    openssl x509 -text -noout -in $CERT_LOCATION/cert.pem

    # check directory
    tree
} 

func_config_traefik() {

    echo "[+] init traefik public network"
    docker network create web-net

    # Add proper tags so traefik will be deployed on the same node
    # docker node update --label-add traefik-public.traefik-public-certificates=true $NODE_ID

    # Let's encrypt configs
    echo "[+] setting encrypt config ..."
    # source .bashrc

    # Deploy the stack
    echo "[+] deploying traefik ..."
    # docker stack deploy -c traefik-compose.swarm.yml traefik > log
    docker-compose -f traefik-compose.yml up -d
}

func_check_permission

source .bashrc

func_create_certs
func_config_traefik
