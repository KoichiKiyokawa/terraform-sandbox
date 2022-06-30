#!/usr/bin/env bash

set -e

export IMAGE_TAG=`git rev-parse HEAD | cut -c 1-7`-`date '+%Y%m%d-%H%M'`
export CONTAINER_REGISTORY_URI=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

aws ecr get-login-password | docker login --username AWS --password-stdin https://${CONTAINER_REGISTORY_URI}

pushd ../nginx
  export URI1=${NGINX_REGISTORY_URI}:latest
  export URI2=${NGINX_REGISTORY_URI}:${IMAGE_TAG}

  docker build -t ${URI1} -t ${URI2} --build-arg APP_SERVER=127.0.0.1 --platform linux/amd64 .

  docker push ${URI1}
  docker push ${URI2}

  export IMAGE_NGINX_URI=${URI2}
popd

pushd ../app
  export URI1=${APP_REGISTORY_URI}:latest
  export URI2=${APP_REGISTORY_URI}:${IMAGE_TAG}

  docker build -t ${URI1} -t ${URI2} --platform linux/amd64 .

  docker push ${URI1}
  docker push ${URI2}

  export IMAGE_APP_URI=${URI2}
popd
