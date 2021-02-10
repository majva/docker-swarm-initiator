export EMAIL=lecerts@hacktor.local
export DOMAIN=traefik.hacktor.local
export USERNAME=admin
export PASSWORD=password
export HASHED_PASSWORD=$(openssl passwd -apr1 $PASSWORD)