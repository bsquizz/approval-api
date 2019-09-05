#!/bin/bash

set -exv

IMAGE="quay.io/cloudservices/approval-api"
IMAGE_TAG=$(git rev-parse --short=7 HEAD)

docker build --no-cache -t "${IMAGE}:${IMAGE_TAG}" .


if [[ -n "$QUAY_USER" && -n "$QUAY_TOKEN" ]]; then
    docker tag "${IMAGE}:${IMAGE_TAG}" "${IMAGE}:latest"

    # set +x so we don't echo the json to stdout
    set +x
    mkdir -p "$WORKSPACE/.docker"
    echo "$QUAY_DOCKER_CONFIG_JSON" > "$WORKSPACE/.docker/config.json"
    set -x

    docker --config="$WORKSPACE/.docker" login -u="$QUAY_USER" -p="$QUAY_TOKEN" quay.io
    docker --config="$WORKSPACE/.docker" push "${IMAGE}:${IMAGE_TAG}"
    docker --config="$WORKSPACE/.docker" push "${IMAGE}:latest"
fi
