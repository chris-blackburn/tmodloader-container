DOCKER=podman
IMAGE_NAME=tmodloader
IMAGE_TAG=latest

.PHONY: all
all:
	$(DOCKER) build -f Dockerfile --ulimit nofile=1024:2048 . -t $(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: run
run:
	mkdir -p serverdata
	$(DOCKER) run --rm -it -p 7777:7777 -p 9019:8080 \
		-v ./serverdata:/opt/serverdata \
		$(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: clean
clean:
	rm -rf serverdata
	$(DOCKER) rmi $(IMAGE_NAME):$(IMAGE_TAG)
