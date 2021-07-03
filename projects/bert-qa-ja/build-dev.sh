#!/bin/bash

DEV_IMAGE=bert-qa-ja-base
DEV_CONTAINER=bert-qa-ja-dev

docker build --target base -f Dockerfile -t ${DEV_IMAGE} .
docker run -itd --gpus all --name="${DEV_CONTAINER}" -v `pwd`:/work -w /work ${DEV_IMAGE}