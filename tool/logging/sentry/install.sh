

check_root_access() {
  if [ "$EUID" -ne 0 ]
    then echo -e "\033[31mRun this script on sudo permission ..."
    exit
  fi
}

check_root_access

source .bashrc

docker network create sentry

docker-compose -f sentry-compose.yml up -d
