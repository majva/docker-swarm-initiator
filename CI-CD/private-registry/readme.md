
# Notation
    -- First of all please login to your docker hub in your registry server with this command
        $ docker login

# Follow below steps
    1- use this command for running bash script to install all necessary dependency for docker private registry
        $ cd 0-Install-private-registry/
        $ bash install.sh
    (**) Note: when command line want from you to complete the certificate info please on FQDN enter you {domain} name that you want to publish the docker registry
        (e.g: registry.hacktor.com)
    2- pull one simple container from docker hub and push it on your own docker registry
        $ docker pull hello-world
        $ docker tag  hello-world:latest localhost:5000/my-hello-world
        $ docker push localhost:5000/my-hello-world
    (**) Note: then you can all images from docker image except registry 
    (**) Note: you can see all your pushed images on this path /root/docker_data/images/docker/registry/v2/repositories

    3- then put you domain.crt file to other docker-slave server
        -- download domain.crt from docker-registry first
        $ cp domain.crt /etc/docker/certs.d/yourdomain.com:5000/
    
    4- now you can pull repository from docker registry with this command
        $ docker pull yourdomain.com:5000/my-hello-world

# if certificates are not provided, then you can disable certificates section 

    1- Create daemon.json file in /etc/docker/daemon.json then add this line to it:
        {
            "insecure-registries" : ["registry.aranuma.com:5000"]
        }