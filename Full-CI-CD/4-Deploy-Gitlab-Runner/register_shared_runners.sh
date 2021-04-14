#!/bin/bash

docker volume create gitlab-runner-data

docker-compose -f gitlab-runner-compose.yml up -d --scale gitlab-runners=5
#docker node update --label-add gitlab-runner.config=true $NODE_ID
#docker stack deploy -c gitlab-runners.docker-compose.swarm.yml gitlab-runners

RUNNER_CONFIG_TEMPLATE=/tmp/runner-config.template.toml
GITLAB_SHARED_REGISTRAION_TOKEN=-VSxCGvxnBb2NNQYDsEV

cat > $RUNNER_CONFIG_TEMPLATE << EOF
[[runners]]
  [runners.docker]
    privileged = true
EOF

GITLAB_INSTANCE_URL=http://192.168.14.144/

docker run --rm -it \
    -v gitlab-runner-data:/etc/gitlab-runner \
    -v $RUNNER_CONFIG_TEMPLATE:$RUNNER_CONFIG_TEMPLATE \
    registry.hacktor.com:5000/gitlab-runner register \
    --non-interactive \
    --template-config $RUNNER_CONFIG_TEMPLATE \
    --url $GITLAB_INSTANCE_URL \
    --registration-token $GITLAB_SHARED_REGISTRAION_TOKEN \
    --executor "docker" \
    --docker-image docker:latest \
    --description "optime_shared_runner" \
    --tag-list "docker,staging,production" \
    --run-untagged="true"
