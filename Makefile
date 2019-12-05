# all targets are phony (no files to check)
.PHONY: default build clean install uninstall push

USER := $(shell grep -P 'ENV\s+USER=".+?"' Dockerfile | cut -d'"' -f2)
NAME := $(shell grep -P 'ENV\s+NAME=".+?"' Dockerfile | cut -d'"' -f2)
VERSION := $(shell grep -P 'ENV\s+VERSION=".+?"' Dockerfile | cut -d'"' -f2)

default: build

build:
	./build.sh

clean:
	echo "Cleaning.."
	docker rmi $(USER)/$(NAME):$(VERSION)

install:
	echo "Installing.."

uninstall:
	echo "Uninstalling.."

push:
	echo "Pushing image to docker hub.."
	docker push $(USER)/$(NAME):$(VERSION)
	docker push $(USER)/$(NAME):latest
