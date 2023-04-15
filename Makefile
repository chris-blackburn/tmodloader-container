DOCKER=podman
IMAGE_NAME=tmodloader
IMAGE_TAG=latest

.PHONY: build
build:
	$(DOCKER) build --format docker \
		--ulimit nofile=1024:2048 \
		-f Dockerfile . -t $(IMAGE_NAME):$(IMAGE_TAG)

Terraria:
	mkdir -p $@

.PHONY: run
run: build | Terraria
	cp config/serverconfig.txt Terraria
	cp config/enabled.json Terraria
	cp config/install.txt Terraria
	$(DOCKER) run --rm -it -p 7777:7777 \
		-v ./Terraria:/opt/terraria/.local/share/Terraria \
		$(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: clean
clean:
	rm -rf Terraria
	$(DOCKER) rmi $(IMAGE_NAME):$(IMAGE_TAG)
