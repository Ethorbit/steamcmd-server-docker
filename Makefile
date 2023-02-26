build: ./Dockerfile ./entrypoint.sh
	docker build --no-cache=true --build-arg TZ="America/Los_Angeles" -t ethorbit/srcds-server:development ./
	touch $@

ifndef VOLUME 
VOLUME := "mygmodserver"
endif

ifdef UID
user_string := --user "$(UID)"
endif

ifdef GID
user_string := $(user_string):"$(GID)"
endif

.PHONY: test
test: build
	docker run -it \
		--name my-gmod-server \
		--rm \
		$(user_string) \
		-p "27015:27015/udp" \
		-v $(VOLUME):/home/srcds/server \
		-e UMASK="0007" \
		-e SRCDS_APPID="4020" \
		-e SRCDS_RUN_ARGS="-port 27015 -tickrate 66 +gamemode 'sandbox' +map 'gm_construct'" \
		ethorbit/srcds-server:development
