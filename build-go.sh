#!/bin/bash

set -ue

#APP=""

_cleanUp() {
	docker rm  "$APP"
	docker rmi "$APP"
} &>/dev/null
trap _cleanUp EXIT

echo "Start building '$APP'"

docker build --build-arg APP="$APP" --tag "$APP" --build-arg MULTIARCH="${1:-}" .
docker create --name "$APP" "$APP"
docker cp "$APP":/build/ .

echo "Build was successful."
echo
