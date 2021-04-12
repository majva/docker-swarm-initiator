
export EMAIL=lecerts@hacktor.com
export DOMAIN=traefik.hacktor.com
export USERNAME=admin
export PASSWORD=password
export HASHED_PASSWORD=$(openssl passwd -apr1 $PASSWORD)
export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
