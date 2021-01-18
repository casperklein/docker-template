# all targets are phony (no files to check)
.PHONY: default build clean install uninstall

SHELL := /bin/bash

APP := $(shell jq -er '.name' < config.json | grep -oP '(?<=docker-).+?(?=-builder)')
VERSION := $(shell jq -er '.version' < config.json)
TAG := $(shell jq -er '"\(.image):\(.version)"' < config.json)

ARCH := $(shell dpkg --print-architecture)

default: build

build:
	@./build-deb.sh "$(debian)"

clean:
	rm -f "$(APP)_$(VERSION)"-1_*.deb
	docker rmi "$(TAG)"

install:
	dpkg -i "$(APP)_$(VERSION)"-1_$(ARCH).deb

uninstall:
	apt-get purge "$(APP)"
