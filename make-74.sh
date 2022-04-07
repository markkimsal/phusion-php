#!/bin/bash -ex
TENSOR="${TENSOR:-}"
SAMBA="${SAMBA:-}"
SQLSRV="${SQLSRV:-}"

IMAGE_NAME=phusion-php
if [ ! -z "$TENSOR" ]; then
	IMAGE_NAME="${IMAGE_NAME}-tensor"
fi
if [ ! -z "$SAMBA" ]; then
	IMAGE_NAME="${IMAGE_NAME}-smb"
fi
if [ ! -z "$SQLSRV" ]; then
	IMAGE_NAME="${IMAGE_NAME}-mssql"
fi

echo "Building tag markkimsal/$IMAGE_NAME ..."

docker build -t markkimsal/php:7.4.26-fpm \
	--build-arg WITH_TENSOR="${TENSOR}" \
	--build-arg WITH_SAMBA="${SAMBA}" \
	--build-arg WITH_SQLSRV="${SQLSRV}" \
	--target=fpm \
	-f ./php-74/Dockerfile-php php-74

docker build -t markkimsal/${IMAGE_NAME}:7.4.26-fpm \
	--build-arg WITH_TENSOR="${TENSOR}" \
	--build-arg WITH_SAMBA="${SAMBA}" \
	--build-arg WITH_SQLSRV="${SQLSRV}" \
	-f ./php-74/Dockerfile-phusion php-74

docker build -t markkimsal/${IMAGE_NAME}:7.4.26-builder \
	--build-arg WITH_TENSOR="${TENSOR}" \
	--build-arg WITH_SAMBA="${SAMBA}" \
	--build-arg WITH_SQLSRV="${SQLSRV}" \
	-f ./php-74/Dockerfile-builder php-74

docker tag markkimsal/${IMAGE_NAME}:7.4.26-builder  markkimsal/${IMAGE_NAME}:7.4-builder
docker tag markkimsal/${IMAGE_NAME}:7.4.26-fpm  markkimsal/${IMAGE_NAME}:7.4-fpm

docker push markkimsal/${IMAGE_NAME}:7.4.26-builder; docker push markkimsal/${IMAGE_NAME}:7.4-builder
docker push markkimsal/${IMAGE_NAME}:7.4.26-fpm;     docker push markkimsal/${IMAGE_NAME}:7.4-fpm
