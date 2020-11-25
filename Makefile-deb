# all targets are phony (no files to check)
.PHONY: default build clean install uninstall

SHELL := /bin/bash

USER := $(shell grep -P 'ENV\s+USER=".+?"' Dockerfile | cut -d'"' -f2)
NAME := $(shell grep -P 'ENV\s+NAME=".+?"' Dockerfile | cut -d'"' -f2)
APP := $(shell grep -P 'ENV\s+NAME=".+?"' Dockerfile | cut -d'"' -f2 | cut -d'-' -f1)
VERSION := $(shell grep -P 'ENV\s+VERSION=".+?"' Dockerfile | cut -d'"' -f2)

ARCH := ${shell			\
	MACHINE=$$(uname -m);	\
	case "$$MACHINE" in	\
        x86_64)			\
                echo "amd64"	\
                ;;		\
        aarch64)		\
                echo "arm64"	\
                ;;		\
        *)			\
                echo "armhf"	\
                ;;		\
        esac			\
}

default: build

build:
	@./build-deb.sh "$(debian)"

clean:
	rm -f "$(APP)_$(VERSION)"-1_*.deb
	docker rmi "$(USER)/$(NAME):$(VERSION)"

install:
	dpkg -i "$(APP)_$(VERSION)"-1_$(ARCH).deb

uninstall:
	apt-get purge "$(APP)"
