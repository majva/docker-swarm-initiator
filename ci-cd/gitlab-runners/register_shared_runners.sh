#!/bin/bash

# docker volume create gitlab-runner-data

# docker-compose -f gitlab-runner-compose.yml up -d --scale gitlab-runners=4

#docker node update --label-add gitlab-runner.config=true $NODE_ID
#docker stack deploy -c gitlab-runners.docker-compose.swarm.yml gitlab-runners

RUNNER_CONFIG_TEMPLATE=/tmp/runner-config.template.toml

# go to admin pannel then go to runner, now put token below 
GITLAB_SHARED_REGISTRAION_TOKEN=${GITLAB_TOKEN?Variable is not set}

cat > $RUNNER_CONFIG_TEMPLATE << EOF
[[runners]]
  executor = "docker"
  [runners.docker]
    tls_verify = false
    privileged = true
    volumes = ["/certs/client", "/cache"]
    [[runners.docker.services]]
      name = "docker:dind"
EOF

# put your gitlab domain below 
GITLAB_INSTANCE_URL=${DOMAIN?Variable is not set}

docker run --rm -it \
    -v gitlab-runner-data:/etc/gitlab-runner \
    -v $RUNNER_CONFIG_TEMPLATE:$RUNNER_CONFIG_TEMPLATE \
    gitlab-runner register \
    --non-interactive \
    --template-config $RUNNER_CONFIG_TEMPLATE \
    --url $GITLAB_INSTANCE_URL \
    --registration-token $GITLAB_SHARED_REGISTRAION_TOKEN \
    --executor "docker" \
    --docker-image docker:latest \
    --description "hacktor_shared_runner" \
    --tag-list "docker,staging,production" \
    --run-untagged="true"
