#!/bin/bash

check_root_access() {
  if [ "$EUID" -ne 0 ]
    then echo -e "\033[31mRun this script on sudo permission ..."
    exit
  fi
}

# check this command executed from sudo user or not
check_root_access

source .bashrc

docker-compose -f graf-prom-compose up -d
