## Add additional worker nodes

- on manager node
$ docker swarm join-token worker

- on worker node
$ docker swarm join --token <token> 192.168.1.1:2377
