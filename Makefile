files := ./servers/*
docker_user := "ethorbit"

.PHONY: build
build:
	docker build -t steamcmd-server ./
	docker image tag steamcmd-server $(docker_user)/steamcmd-server
	find $(files) -maxdepth 1 -type d -exec \
		/bin/sh -c 'dirname=$$(basename {}) &&\
		docker build -t $$dirname {} &&\
		docker image tag $$dirname $(docker_user)/$$dirname' \;

.PHONY: push
push:
	docker image push $(docker_user)/steamcmd-server
	find $(files) -maxdepth 1 -type d -exec \
		/bin/sh -c 'dirname=$$(basename {}) &&\
		docker image push $(docker_user)/$$dirname' \;

.PHONY: steamcmd
steamcmd:
	docker run -it --rm --name steamcmd steamcmd-server /bin/sh

svencoop:
	docker run -it --rm --name svencoop svencoop-server

#gmod:

#.PHONY: test
#test: build
#	docker run -it \
#		--name my-gmod-server \
#		--rm \
#		$(user_string) \
#		-p "27015:27015/udp" \
#		-v $(VOLUME):/home/srcds/server \
#		-e UMASK="0007" \
#		-e SRCDS_APPID="4020" \
#		-e SRCDS_RUN_ARGS="-port 27015 -tickrate 66 +gamemode 'sandbox' +map 'gm_construct'" \
#		ethorbit/srcds-server:development
