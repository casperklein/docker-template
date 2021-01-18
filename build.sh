#!/bin/bash

set -ueo pipefail

IMAGE=$(jq -er '.image'			< config.json)
TAG=$(jq -er '"\(.image):\(.version)"'	< config.json)

DIR=${0%/*}
cd "$DIR"

echo "Building: $TAG"
echo
docker build -t "$TAG" .
docker tag "$TAG" "$IMAGE:latest"
