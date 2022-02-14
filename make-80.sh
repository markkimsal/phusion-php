#!/bin/bash -ex
TENSOR="${TENSOR:-}"
SAMBA="${SAMBA:-}"
SQLSRV="${SQLSRV:-}"
GRPC="${GRPC:-}"
IMAGICK="${IMAGICK:-}"
GMAGICK="${GMAGICK:-}"

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
if [ ! -z "$GRPC" ]; then
	IMAGE_NAME="${IMAGE_NAME}-grpc"
fi
if [ ! -z "$IMAGICK" ]; then
	IMAGE_NAME="${IMAGE_NAME}-imagick"
fi
if [ ! -z "$GMAGICK" ]; then
	IMAGE_NAME="${IMAGE_NAME}-gmagick"
fi


echo "Building tag markkimsal/$IMAGE_NAME ..."

echo "docker build -t markkimsal/php:8.0.15-fpm \
	--build-arg WITH_TENSOR="${TENSOR}" \
	--build-arg WITH_SAMBA="${SAMBA}" \
	--build-arg WITH_SQLSRV="${SQLSRV}" \
	--build-arg WITH_GRPC="${GRPC}" \
	--build-arg WITH_IMAGICK="${IMAGICK}" \
	--build-arg WITH_GMAGICK="${GMAGICK}" \
	--target=fpm \
	-f ./php-80/Dockerfile-php php-80"


docker build -t markkimsal/php:8.0.15-fpm \
	--build-arg WITH_TENSOR="${TENSOR}" \
	--build-arg WITH_SAMBA="${SAMBA}" \
	--build-arg WITH_SQLSRV="${SQLSRV}" \
	--build-arg WITH_GRPC="${GRPC}" \
	--build-arg WITH_IMAGICK="${IMAGICK}" \
	--build-arg WITH_GMAGICK="${GMAGICK}" \
	--target=fpm \
	-f ./php-80/Dockerfile-php php-80

docker build -t markkimsal/$IMAGE_NAME:8.0.15-fpm \
	--build-arg WITH_TENSOR="${TENSOR}" \
	--build-arg WITH_SAMBA="${SAMBA}" \
	--build-arg WITH_SQLSRV="${SQLSRV}" \
	--build-arg WITH_GRPC="${GRPC}" \
	--build-arg WITH_IMAGICK="${IMAGICK}" \
	--build-arg WITH_GMAGICK="${GMAGICK}" \
	-f ./php-80/Dockerfile-phusion php-80

docker build -t markkimsal/$IMAGE_NAME:8.0.15-builder \
	--build-arg WITH_TENSOR="${TENSOR}" \
	--build-arg WITH_SAMBA="${SAMBA}" \
	--build-arg WITH_SQLSRV="${SQLSRV}" \
	--build-arg WITH_GRPC="${GRPC}" \
	--build-arg WITH_IMAGICK="${IMAGICK}" \
	--build-arg WITH_GMAGICK="${GMAGICK}" \
	-f ./php-80/Dockerfile-builder php-80

docker tag markkimsal/$IMAGE_NAME:8.0.15-builder  markkimsal/$IMAGE_NAME:8.0-builder
docker tag markkimsal/$IMAGE_NAME:8.0.15-fpm  markkimsal/$IMAGE_NAME:8.0-fpm
docker tag markkimsal/$IMAGE_NAME:8.0.15-fpm  markkimsal$IMAGE_NAMEp:latest

docker push markkimsal/$IMAGE_NAME:8.0.15-builder; docker push markkimsal/$IMAGE_NAME:8.0-builder
docker push markkimsal/$IMAGE_NAME:8.0.15-fpm;     docker push markkimsal/$IMAGE_NAME:8.0-fpm
docker push markkimsal/$IMAGE_NAME:latest
