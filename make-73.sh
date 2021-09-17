docker build -t markkimsal/phusion-lemp:7.3.30-mssql -f ./php-73/Dockerfile-mssql php-73
docker build -t markkimsal/phusion-lemp:7.3.30-pgsql -f ./php-73/Dockerfile-pgsql php-73
docker build -t markkimsal/phusion-lemp:7.3.30-mysql -f ./php-73/Dockerfile-mysql php-73
docker build -t markkimsal/phusion-lemp:7.3.30-builder -f ./php-73/Dockerfile-builder php-73

docker tag markkimsal/phusion-lemp:7.3.30-builder markkimsal/phusion-lemp:7.3-builder
docker tag markkimsal/phusion-lemp:7.3.30-mysql markkimsal/phusion-lemp:7.3-mysql
docker tag markkimsal/phusion-lemp:7.3.30-pgsql markkimsal/phusion-lemp:7.3-pgsql
docker tag markkimsal/phusion-lemp:7.3.30-mssql markkimsal/phusion-lemp:7.3-mssql
