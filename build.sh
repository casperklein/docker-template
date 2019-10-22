#!/bin/bash

set -ueo pipefail

USER="casperklein"
NAME=$(grep NAME= Dockerfile | cut -d'"' -f2)
VERSION=$(grep VERSION= Dockerfile | cut -d'"' -f2)
TAG="$USER/$NAME:$VERSION"

DIR=${0%/*}
cd "$DIR"

echo "Building: $NAME $VERSION"
echo
docker build -t "$TAG" .

#echo "Copy $NAME $VERSION debian package to $(pwd)/"
#docker run --rm -v "$(pwd)":/mnt/ "$TAG"
#echo
