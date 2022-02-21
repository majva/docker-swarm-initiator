#!/bin/bash

source .bashrc

func_check_permission() {
  if [ "$EUID" -ne 0 ]
    then echo "run this script on sudo permission"
    exit
  fi
}

func_check_permission

docker-compose -f nexus-compose.yml up -d
