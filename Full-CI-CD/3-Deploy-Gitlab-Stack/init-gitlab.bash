#!/bin/bash

# Create Volumes

echo "Creating volumes ..."

docker volume create gitlab-data
docker volume create redis-data
docker volume create postgresql-data
docker volume create registry-data
docker volume create certs-data

echo "add proper node labels ..."
docker node update --label-add gitlab.certs-data=true $NODE_ID
docker node update --label-add gitlab.redis-data=true $NODE_ID
docker node update --label-add gitlab.postgresql-data=true $NODE_ID
docker node update --label-add gitlab.gitlab-data=true $NODE_ID
docker node update --label-add gitlab.registry-data=true $NODE_ID

# Deploy Stack

echo "deploing stack ..."

export GITLAB_HOST=git.hacktor.local
export REGISTRY_HOST=registry.hacktor.local

docker stack deploy -c gitlab.docker-compose.swarm.yml gitlab > logs
