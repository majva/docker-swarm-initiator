#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "run this script on sudo permission"
  exit
fi

echo "Please check that /etc/docker/daemon.json is empty or not"

read -p "Is empty? <y/n>: " answer

function write_docker_registry_url() {
    local retval='
        {
            "registry-mirrors": ["https://dockerhub.ir"]
        }
    '
    echo $retval
}

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo  $(write_docker_registry_url) > ./daemon.json
else
    echo 'so add this line to json => "registry-mirrors": ["https://dockerhub.ir"]'
fi

sudo systemctl restart docker
