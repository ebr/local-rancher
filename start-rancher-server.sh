#!/bin/sh

MACHINE=$1
YAML_FILEPATH=/var/lib/rancher/conf/rancher.yml

eval $(docker-machine env $MACHINE)

export DOCKER_TLS_VERIFY
export DOCKER_HOST
export DOCKER_CERT_PATH
export DOCKER_MACHINE_NAME


# docker run -d -v rancher-mysql:/var/lib/mysql --restart=unless-stopped -p 8080:8080 rancher/server

# export RANCHER_URL=$(docker-machine inspect ${MACHINE} -f {{.Driver.IPAddress}})

# docker-machine env $MACHINE

docker build -f Dockerfile_cli . -t local/rancher-cli

cat docker-compose.yml | docker-machine ssh ${MACHINE} "sudo tee ${YAML_FILEPATH}"
docker-machine ssh ${MACHINE} "sudo ros service enable ${YAML_FILEPATH}"
# docker-machine ssh ${MACHINE} "sudo ros service build ${YAML_FILEPATH}"
docker-machine ssh ${MACHINE} "sudo ros service up -d rancher-server"


#docker run -it --link rancher-server:rancher -e RANCHER_URL=http://rancher:8080 local/rancher-cli hosts
