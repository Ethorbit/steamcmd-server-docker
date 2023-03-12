docker_user := "ethorbit"
files := ./servers/*

.PHONY: build test push

build:
	docker build -t steamcmd-server ./
	find $(files) -maxdepth 1 -type d -exec \
		/bin/sh -c 'dirname=$$(basename {}) &&\
		docker build -t $$dirname {} &&\
		docker volume rm -f $$dirname' \;

test:
	docker run -it --rm -p 27015:27015/udp -v $(image):/home/steam/server --name $(image) $(image) $(command)

push:
	find $(files) -maxdepth 1 -type d -exec \
		/bin/sh -c 'dirname=$$(basename {}) &&\
		docker tag $$dirname $(docker_user)/$$dirname:$$(git rev-parse --short HEAD) &&\
		docker tag $$dirname $(docker_user)/$$dirname:latest &&\
		docker push -a $(docker_user)/$$dirname' \;
