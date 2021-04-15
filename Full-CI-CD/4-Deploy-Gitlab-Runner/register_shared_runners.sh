#!/bin/bash

docker volume create gitlab-runner-data

docker-compose -f gitlab-runner-compose.yml up -d --scale gitlab-runners=4

#docker node update --label-add gitlab-runner.config=true $NODE_ID
#docker stack deploy -c gitlab-runners.docker-compose.swarm.yml gitlab-runners

RUNNER_CONFIG_TEMPLATE=/tmp/runner-config.template.toml

# go to admin pannel then go to runner, now put token below 
GITLAB_SHARED_REGISTRAION_TOKEN=-VSxCGvxnBb2NNQYDsEV

cat > $RUNNER_CONFIG_TEMPLATE << EOF
[[runners]]
  name = "some_name"
  url = "https://my.url.com"
  token = "a_token"
  executor = "docker"
  pre_build_script = "export DOCKER_HOST=tcp://docker:2375"
  environment = ["DOCKER_DRIVER=overlay2", "DOCKER_TLS_CERTDIR="]
  [runners.docker]
    tls_verify = false
    image = "docker:stable"
    privileged = true
    extra_hosts = ["gitlab.hacktor.com:192.168.14.140"]
    volumes = ["/cache", "/var/run/docker.sock:/var/run/docker.sock"]
EOF

# put your gitlab domain below 
GITLAB_INSTANCE_URL=http://192.168.14.140/

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
    --description "hacktor_shared_runner" \
    --tag-list "docker,staging,production" \
    --run-untagged="true"
