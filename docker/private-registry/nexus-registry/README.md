## Install

- run this command on your node
    ```
        bash install.sh
    ```

# Note
- this compose will work with traefik reverse proxy then if you wanna run it without the any proxy then you must un-comment 
the port section and then comment the label section in nexus-compose.yml file then run the install command.

- if you wanna connect to registry and then push the image to it, you must add this below lines to docker daemon.json file in this 
path: /etc/docker/daemon.json.
if it not exist in this path you must create it.
then put this lines to it as json of root of element.
    ```
        "insecure-registries" : [ "http://domain:port" ]
    ```
then restart docker service with this command
    ```
        service docker restart
    ```