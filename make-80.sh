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

docker build -t markkimsal/php:8.0.10-fpm \
	--build-arg WITH_TENSOR="${TENSOR}" \
	--build-arg WITH_SAMBA="${SAMBA}" \
	--build-arg WITH_SQLSRV="${SQLSRV}" \
	--target=fpm \
	-f ./php-80/Dockerfile-php php-80

docker build -t markkimsal/$IMAGE_NAME:8.0.10-fpm \
	--build-arg WITH_TENSOR="${TENSOR}" \
	--build-arg WITH_SAMBA="${SAMBA}" \
	--build-arg WITH_SQLSRV="${SQLSRV}" \
	-f ./php-80/Dockerfile-phusion php-80

docker build -t markkimsal/$IMAGE_NAME:8.0.10-builder \
	--build-arg WITH_TENSOR="${TENSOR}" \
	--build-arg WITH_SAMBA="${SAMBA}" \
	--build-arg WITH_SQLSRV="${SQLSRV}" \
	-f ./php-80/Dockerfile-builder php-80

docker tag markkimsal/$IMAGE_NAME:8.0.10-builder  markkimsal/$IMAGE_NAME:8.0-builder
docker tag markkimsal/$IMAGE_NAME:8.0.10-fpm  markkimsal/$IMAGE_NAME:8.0-fpm
docker tag markkimsal/$IMAGE_NAME:8.0.10-fpm  markkimsal$IMAGE_NAMEp:latest

docker push markkimsal/$IMAGE_NAME:8.0.10-builder; docker push markkimsal/$IMAGE_NAME:8.0-builder
docker push markkimsal/$IMAGE_NAME:8.0.10-fpm;     docker push markkimsal/$IMAGE_NAME:8.0-fpm
docker push markkimsal/$IMAGE_NAME:8.0.10-fpm;     docker push markkimsal/$IMAGE_NAME:latest
