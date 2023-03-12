files := ./servers/*
docker_user := "ethorbit"

.PHONY: build
build:
	docker build -t steamcmd-server ./
	docker image tag steamcmd-server $(docker_user)/steamcmd-server
	find $(files) -maxdepth 1 -type d -exec \
		/bin/sh -c 'dirname=$$(basename {}) &&\
		docker build -t $$dirname {} &&\
		docker image tag $$dirname $(docker_user)/$$dirname &&\
		docker volume rm -f $$dirname' \;

.PHONY: test clean
test:
	docker run -it --rm -v $(image):/home/steam/server --name $(image) $(image) $(command)

clean:
	docker volume rm -f $(image)

.PHONY: push
push:
	docker image push $(docker_user)/steamcmd-server
	find $(files) -maxdepth 1 -type d -exec \
		/bin/sh -c 'dirname=$$(basename {}) &&\
		docker image push $(docker_user)/$$dirname' \;
