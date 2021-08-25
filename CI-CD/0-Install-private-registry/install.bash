#!/bin/bash

check_root_access() {
    if [ "$EUID" -ne 0 ]
    then echo -e 'Run this script on sudo permission ...'
        exist
    fi
}

check_root_access
