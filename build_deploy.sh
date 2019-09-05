#!/bin/bash

set -exv

IMAGE="quay.io/cloudservices/approval-api"
IMAGE_TAG=$(git rev-parse --short=7 HEAD)

docker build --no-cache -t "${IMAGE}:${IMAGE_TAG}" .


if [[ -n "$QUAY_USER" && -n "$QUAY_TOKEN" ]]; then
    docker tag "${IMAGE}:${IMAGE_TAG}" "${IMAGE}:latest"
    docker --config="$QUAY_DOCKER_CONFIG_JSON" login -u="$QUAY_USER" -p="$QUAY_TOKEN" quay.io
    docker --config="$QUAY_DOCKER_CONFIG_JSON" push "${IMAGE}:${IMAGE_TAG}"
    docker --config="$QUAY_DOCKER_CONFIG_JSON" push "${IMAGE}:latest"
fi
