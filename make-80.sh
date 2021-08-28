
docker build -t markkimsal/php:8.0.10-fpm --target=fpm -f ./php-80/Dockerfile-php php-80
docker build -t markkimsal/phusion-php:8.0.10-fpm -f ./php-80/Dockerfile-phusion php-80
docker build -t markkimsal/phusion-php:8.0.10-builder -f ./php-80/Dockerfile-builder php-80

docker tag markkimsal/phusion-php:8.0.10-builder  markkimsal/phusion-php:8.0-builder
docker tag markkimsal/phusion-php:8.0.10-fpm  markkimsal/phusion-php:8.0-fpm
docker tag markkimsal/phusion-php:8.0.10-fpm  markkimsal/phusion-php:latest
