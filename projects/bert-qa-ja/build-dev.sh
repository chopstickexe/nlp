#!/bin/bash

DEV_IMAGE=bert-qa-ja-dev
DEV_CONTAINER=bert-qa-ja-dev

docker build --target dev -f Dockerfile -t ${DEV_IMAGE} .
docker run -itd --gpus all --name="${DEV_CONTAINER}" \
  -v `pwd`:/work \
  -w /work \
  -e LOCAL_UID=$(id -u $USER) \
  -e LOCAL_GID=$(id -g $USER) \
  -e LOCAL_USER=$USER \
  ${DEV_IMAGE} bash
