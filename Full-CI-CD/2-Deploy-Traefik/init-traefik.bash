docker network create --driver=overlay traefik-public

# Get NodeID for this node
export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')

# Add proper tags so traefik will be deployed on the same node
docker node update --label-add traefik-public.traefik-public-certificates=true $NODE_ID

# Let's encrypt configs
bash env.bash
echo "[+] set encrypt config"

# Deploy the stack
echo "[+] deploying traefik ..."
docker stack deploy -c traefik.docker-compose.swarm.yml traefik
