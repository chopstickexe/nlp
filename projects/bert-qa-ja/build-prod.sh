#!/bin/bash

PROD_IMAGE_NAME=bert-qa-ja

# poetry export --without-hashes --dev -f requirements.txt -o requirements.txt

docker build --target prod -f Dockerfile -t ${PROD_IMAGE_NAME} .
