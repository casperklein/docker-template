#!/bin/bash

set -ueo pipefail

TAG=$(jq -er '"\(.image):\(.version)"'	< config.json)
APP=$(jq -er '.name'			< config.json | grep -oP '(?<=docker-).+?(?=-builder)') # docker-app-builder

MACHINE=$(uname -m)
case "$MACHINE" in
	x86_64)
		ARCH="amd64"
	       ;;
	aarch64)
		ARCH="arm64"
		;;
	*)
		ARCH="armhf"
		;;
esac

[ -n "${1:-}" ] && DEBIAN_VERSION="--build-arg version=$1"

DIR=${0%/*}
cd "$DIR"

echo "Building: $APP $VERSION"
echo
MAKEFLAGS=${MAKEFLAGS:-}
MAKEFLAGS=${MAKEFLAGS//--jobserver-auth=[[:digit:]],[[:digit:]]/}
docker build -t "$TAG" ${DEBIAN_VERSION:-} --build-arg MAKEFLAGS="${MAKEFLAGS:-}" .
echo

echo "Copy $APP $VERSION debian package to $PWD/"
docker run --rm -v "$PWD":/mnt/ "$TAG"
echo

dpkg -I "${APP}_${VERSION}"-1_${ARCH}.deb
echo
