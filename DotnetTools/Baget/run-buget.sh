#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "run this script on sudo permission"
  exit
fi

docker-compose -f ./baget-compose.yml up -d
