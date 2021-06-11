
- init network for traefik
$ docker network create --driver=overlay traefik-public

- Deploy the stack
$ docker stack deploy -c traefik.docker-compose.swarm.yml traefik
