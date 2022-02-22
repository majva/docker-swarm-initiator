#!/bin/bash

source .bashrc

func_check_permission() {
  if [ "$EUID" -ne 0 ]
    then echo "run this script on sudo permission"
    exit
  fi
}

func_check_permission

docker-compose -f gitlab-compose.yml up -d

# Create Volumes


# echo "add proper node labels ..."
# docker node update --label-add gitlab.certs-data=true $NODE_ID
# docker node update --label-add gitlab.redis-data=true $NODE_ID
# docker node update --label-add gitlab.postgresql-data=true $NODE_ID
# docker node update --label-add gitlab.gitlab-data=true $NODE_ID
# docker node update --label-add gitlab.registry-data=true $NODE_ID

# Deploy Stack

# echo "deploing stack ..."
# docker stack deploy -c gitlab-compose.swarm.yml gitlab > logs


