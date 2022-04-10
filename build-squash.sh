#!/bin/bash

set -ueo pipefail

VERSION=$(jq -er '.version'		< config.json)
IMAGE=$(jq -er '.image'			< config.json)
TAG=$(jq -er '"\(.image):\(.version)"'	< config.json)

DIR=${0%/*}
cd "$DIR"

echo "Creating squashed Dockerfile.."
docker-squash > Dockerfile.squash

echo "Building: $TAG"
echo
docker build -f Dockerfile.squash -t "$TAG" --build-arg VERSION="$VERSION" .
docker tag "$TAG" "$IMAGE:latest"

