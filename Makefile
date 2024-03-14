docker_user := "ethorbit"
files := ./servers/*
git_hash := $(shell git rev-parse --short HEAD)

.PHONY: build test push

build:
	docker build -t steamcmd-server ./
	find $(files) -maxdepth 0 -type d -exec \
		/bin/sh -c 'dirname=$$(basename {}) &&\
		docker build -t $$dirname -t $(docker_user)/$$dirname:latest -t $(docker_user)/$$dirname:$(git_hash) {} &&\
		[ 1 = 0 ] && docker volume rm -f $$dirname' \;

test:
	docker run -it --rm -p 27015/udp -p 27015/tcp $(options) -v $(image):/home/steam/Steam/steamapps/common --name $(image) $(image) $(command)

push:
	find $(files) -maxdepth 1 -type d -exec \
		/bin/sh -c 'dirname=$$(basename {}) &&\
		docker push $(docker_user)/$$dirname:$(git_hash) &&\
		docker push $(docker_user)/$$dirname:latest' \;

