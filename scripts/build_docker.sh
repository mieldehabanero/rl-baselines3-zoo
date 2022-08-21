#!/bin/bash

CPU_PARENT=ubuntu:20.04
GPU_PARENT=nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu20.04

TAG=habaneroforever/rl-baselines3-zoo
VERSION=1.5.1a6

if [[ ${USE_GPU} == "True" ]]; then
  PARENT=${GPU_PARENT}
  PYTORCH_DEPS="cudatoolkit==11.7"
else
  PARENT=${CPU_PARENT}
  PYTORCH_DEPS="cpuonly"
  TAG="${TAG}-cpu"
fi

docker build --build-arg PARENT_IMAGE=${PARENT} --build-arg PYTORCH_DEPS=${PYTORCH_DEPS} -t ${TAG}:${VERSION} . -f docker/Dockerfile
docker tag ${TAG}:${VERSION} ${TAG}:latest

if [[ ${RELEASE} == "True" ]]; then
  docker push ${TAG}:${VERSION}
  docker push ${TAG}:latest
fi
