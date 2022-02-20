
export EMAIL=topcodermc@gmail.com
export DOMAIN=traefik.hacktor.local
export USERNAME=admin
export PASSWORD=password
export HASHED_PASSWORD=$(openssl passwd -apr1 $PASSWORD)
# export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
# export DOCKER_REGISTRY_HOST=registry.hacktor.com:5000