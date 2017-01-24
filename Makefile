PWD := $(shell pwd)
MACHINE_PREFIX := ros
NUM_HOSTS = 2

# setup:
# 	curl -slO https://raw.githubusercontent.com/nathanleclaire/dockerfiles/master/ansible/machine.py

# provision:
# 	docker run -it -v ${PWD}:/ansible local/ansible --version

setup:
	curl -slO https://releases.rancher.com/os/latest/rancheros.iso

hosts:
	@for i in {1..${NUM_HOSTS}}; do docker-machine create -d virtualbox --virtualbox-boot2docker-url ./rancheros.iso ${MACHINE_PREFIX}-$$i & done
	@echo ""

rancher:
	# $(eval MACHINE := $(shell docker-machine inspect ${MACHINE_PREFIX}-1 -f "{{.Driver.IPAddress}}"))
	./start-rancher-server.sh ${MACHINE_PREFIX}-1

cli:
	docker build -f Dockerfile_cli . -t local/rancher-cli

## must be init'd against a ROS host
kube:
	$(eval KUBE_ENV := $(shell docker run -it --link rancher-server:rancher -e RANCHER_URL=http://rancher:8080 local/rancher-cli env create -t kubernetes mykube))
	@echo "Kube environment is ${KUBE_ENV}"
	docker run -it --link rancher-server:rancher -e RANCHER_URL=http://rancher:8080 local/rancher-cli --env=${KUBE_ENV} hosts ls

teardown:
	@for i in {1..${NUM_HOSTS}}; do docker-machine rm -y ${MACHINE_PREFIX}-$$i & done
	@echo ""
