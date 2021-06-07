#docker build -t markkimsal/php:8.0.7-fpm --target=fpm -f ./php-80/Dockerfile-fpm php-80
#docker build -t markkimsal/phusion-php:8.0.7-fpm -f ./php-80/Dockerfile-fpm php-80
docker build -t markkimsal/phusion-php:8.0.7-builder -f ./php-80/Dockerfile-builder php-80
