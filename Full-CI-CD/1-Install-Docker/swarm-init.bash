#!/bin/bash

docker swarm init > swarm-token

docker node ls

bash .bashrc
