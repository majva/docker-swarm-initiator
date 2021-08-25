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
