#!/bin/bash

docker swarm init > swarm-token

docker node ls

export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
