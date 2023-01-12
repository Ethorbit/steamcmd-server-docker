build: ./Dockerfile
	docker build -t ethorbit/srcds-server:development ./

ifndef VOLUME 
VOLUME := "mygmodserver"
endif

ifdef USER_ID
user_string := --user "$(USER_ID)"
endif

ifdef GROUP_ID
user_string := $(user_string):"$(GROUP_ID)"
endif

.PHONY test: build
	docker run -it \
		--name my-gmod-server \
		--rm \
		$(user_string) \
		-p "27015:27015/udp" \
		-v $(VOLUME):/home/srcds/server \
		-e SRCDS_APPID="4020" \
		-e SRCDS_RUN_ARGS="-port 27015 -tickrate 66 +gamemode 'sandbox' +map 'gm_construct'" \
		ethorbit/srcds-server:development
