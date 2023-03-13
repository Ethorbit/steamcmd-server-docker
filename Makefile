docker_user := "ethorbit"
files := ./servers/*
git_hash := $(shell git rev-parse --short HEAD)

.PHONY: build test push

build:
	docker build -t steamcmd-server ./
	find $(files) -maxdepth 1 -type d -exec \
		/bin/sh -c 'dirname=$$(basename {}) &&\
		docker build -t $(docker_user)/$$dirname:latest -t $(docker_user)/$$dirname:$(git_hash) {} &&\
		docker volume rm -f $$dirname' \;

test:
	docker run -it --rm -p 27015:27015/udp $(options) -v $(image):/home/steam/server --name $(image) $(image) $(command)

push:
	find $(files) -maxdepth 1 -type d -exec \
		/bin/sh -c 'dirname=$$(basename {}) &&\
		docker push $(docker_user)/$$dirname:$(git_hash) &&\
		docker push $(docker_user)/$$dirname:latest' \;

