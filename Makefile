APP := devenv
OSS := true
_ := $(shell ./scripts/bootstrap-lib.sh) 

include .bootstrap/root/Makefile

###Block(targets)
.PHONY: install
install: build
	@devenvPath="$$(command -v devenv)"; if [[ -w "$$devenvPath" ]]; then cp -v ./bin/devenv "$$devenvPath"; else sudo cp -v ./bin/devenv "$$devenvPath"; fi

.PHONY: docker-build-override
docker-build-override:
	docker buildx build --platform "linux/amd64,linux/arm64" --ssh default -t "gcr.io/outreach-docker/devenv:$(APP_VERSION)" .

.PHONY: docker-push-override
docker-push-override:
	docker buildx build --platform "linux/amd64,linux/arm64" --ssh default -t "gcr.io/outreach-docker/devenv:$(APP_VERSION)" --push .
###EndBlock(targets)
