
docker build -t markkimsal/php:7.4.23-fpm --target=fpm -f ./php-74/Dockerfile-php php-74
docker build -t markkimsal/phusion-php:7.4.23-fpm -f ./php-74/Dockerfile-phusion php-74
docker build -t markkimsal/phusion-php:7.4.23-builder -f ./php-74/Dockerfile-builder php-74

docker tag markkimsal/phusion-php:7.4.23-builder  markkimsal/phusion-php:7.4-builder
docker tag markkimsal/phusion-php:7.4.23-fpm  markkimsal/phusion-php:7.4-fpm
