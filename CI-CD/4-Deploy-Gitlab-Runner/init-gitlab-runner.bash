#!/bin/bash

source .bashrc

echo "deploing stack ..."
docker stack deploy -c gitlab-runners-compose.swarm.yml gitlab > logs

echo "done"