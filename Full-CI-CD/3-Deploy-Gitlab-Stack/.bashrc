
export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
export GITLAB_HOST=git.hacktor.local
export REGISTRY_HOST=registry.hacktor.local
export GITLAB_EMAIL=git@hacktor.local
export GITLAB_EMAIL_REPLY_TO=git@hacktor.local
export GITLAB_INCOMING_EMAIL_ADDRESS=git@hacktor.local
export GITLAB_ROOT_PASSWORD=password
export GITLAB_ROOT_EMAIL=admin@hacktor.local
export DOCKER_REGISTRY_HOST=registry.hacktor.com:5000