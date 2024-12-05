#!/usr/bin/env bash

docker buildx build \
  --push \
  --platform=linux/amd64 \
  -t themonitoringshop/c10e-instruqt-chromium:latest \
  -f Dockerfile . 
