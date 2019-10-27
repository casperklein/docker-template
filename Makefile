# all targets are phony (no files to check)
.PHONY: default build clean install uninstall

default: build

build:
	./build.sh

clean:
	echo "Cleaning.."
	USER=$$(grep -P 'ENV\s+USER=".+?"' Dockerfile | cut -d'"' -f2) && \
	NAME=$$(grep -P 'ENV\s+NAME=".+?"' Dockerfile | cut -d'"' -f2) && \
	VERSION=$$(grep -P 'ENV\s+VERSION=".+?"' Dockerfile | cut -d'"' -f2) && \
	docker rmi $$USER/$$NAME:$$VERSION

install:
	echo "Installing.."

uninstall:
	echo "Uninstalling.."
