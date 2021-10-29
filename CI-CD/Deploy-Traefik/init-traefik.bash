#!/bin/bash

echo "[+] init traefik public network"
docker network create --driver=overlay traefik-public

# Add proper tags so traefik will be deployed on the same node
docker node update --label-add traefik-public.traefik-public-certificates=true $NODE_ID

# Let's encrypt configs
echo "[+] setting encrypt config ..."
source .bashrc

# Deploy the stack
echo "[+] deploying traefik ..."
docker stack deploy -c traefik-compose.swarm.yml traefik > log
