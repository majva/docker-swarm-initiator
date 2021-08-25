#!/bin/bash

docker swarm init > swarm-token

docker node ls

source .bashrc
