#!/bin/bash

set -exv

IMAGE="quay.io/cloudservices/approval-api"
IMAGE_TAG=$(git rev-parse --short=7 HEAD)

docker build --no-cache -t "${IMAGE}:${IMAGE_TAG}" .


if [[ -n "$QUAY_USER" && -n "$QUAY_TOKEN" ]]; then
    docker tag "${IMAGE}:${IMAGE_TAG}" "${IMAGE}:latest"

    # set +x so we don't echo the json to stdout
    set +x
    echo "$QUAY_DOCKER_CONFIG_JSON" > .docker_config.json
    set -x

    docker --config=".docker_config.json" login -u="$QUAY_USER" -p="$QUAY_TOKEN" quay.io
    docker --config=".docker_config.json" push "${IMAGE}:${IMAGE_TAG}"
    docker --config=".docker_config.json" push "${IMAGE}:latest"
fi
