#!/bin/bash

echo "[+] init traefik public network"
docker network create --driver=overlay traefik-public

# Get NodeID for this node
export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')

# Add proper tags so traefik will be deployed on the same node
docker node update --label-add traefik-public.traefik-public-certificates=true $NODE_ID

# Let's encrypt configs
echo "[+] setting encrypt config ..."
pass=password
export EMAIL=lecerts@hacktor.local
export DOMAIN=traefik.gitlab.hacktor.local
export USERNAME=admin
export PASSWORD=$pass
export HASHED_PASSWORD=$(openssl passwd -apr1 $PASSWORD)

# Deploy the stack
echo "[+] deploying traefik ..."
docker stack deploy -c traefik.docker-compose.swarm.yml traefik > log
