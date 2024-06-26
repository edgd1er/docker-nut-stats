DOCKER=/usr/bin/docker
DOCKER_IMAGE_NAME=edgd1er/nut-stats
PTF=linux/amd64
DKRFILE=Dockerfile
ARCHI := $(shell dpkg --print-architecture)
IMAGE=nut-stats
PROGRESS=auto
WHERE=--load
CACHE=
aptCacher:=$(shell ifconfig wlp2s0 | awk '/inet /{print $$2}')

default: build
all: lint build test

lint:
	$(DOCKER) run --rm -i hadolint/hadolint < Build/Dockerfile

build:
	$(DOCKER) buildx build $(WHERE) --platform $(PTF) --build-arg NAME=$(NAME) \
    $(CACHE) --progress $(PROGRESS) --build-arg aptCacher=$(aptCacher) -t $(IMAGE) Build

push:
	$(DOCKER) login
	$(DOCKER) push $(DOCKER_IMAGE_NAME)

test:
	$(DOCKER) run -p "8282:80" -p "2443:443" --rm --name nut $(DOCKER_IMAGE_NAME)

clean:
	$(DOCKER) images -qf dangling=true | xargs --no-run-if-empty $(DOCKER) rmi
	$(DOCKER) volume ls -qf dangling=true | xargs --no-run-if-empty $(DOCKER) volume rm
