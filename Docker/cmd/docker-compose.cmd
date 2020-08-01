$ docker-compose up => to build the app with the updated Compose file
$ docker-compose up -d  => If you want to run your services in the background
$ docker-compose ps => to see what is currently running 
$ docker-compose stop => If you started Compose with docker-compose up -d, stop your services once you’ve finished with them
$ docker-compose down --volumes => You can bring everything down, removing the containers entirely, with the down command. Pass --volumes to also remove the data volume used by the Redis container


