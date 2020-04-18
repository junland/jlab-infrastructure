PWD := $(shell pwd)
GIT_COMMIT:=$(shell git rev-parse --verify HEAD --short=7)
CENGINE := docker

.PHONY: test
test:
	$(CENGINE) build -f ./test/Dockerfile.centos .