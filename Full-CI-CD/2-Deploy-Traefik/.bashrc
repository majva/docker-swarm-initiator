
export EMAIL=lecerts@hacktor.local
export DOMAIN=traefik.gitlab.hacktor.local
export USERNAME=admin
export PASSWORD=password
export HASHED_PASSWORD=$(openssl passwd -apr1 $PASSWORD)
export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
