docker build -t markkimsal/phusion-lemp:7.3.30-mssql -f ./Dockerfile-mssql .
docker build -t markkimsal/phusion-lemp:7.3.30-pgsql -f ./Dockerfile-pgsql .
docker build -t markkimsal/phusion-lemp:7.3.30-mysql -f ./Dockerfile-mysql .
docker build -t markkimsal/phusion-lemp:7.3.30-builder -f ./Dockerfile-builder .

docker tag markkimsal/phusion-lemp:7.3.30-builder markkimsal/phusion-lemp:7.3-builder
docker tag markkimsal/phusion-lemp:7.3.30-mysql markkimsal/phusion-lemp:7.3-mysql
docker tag markkimsal/phusion-lemp:7.3.30-pgsql markkimsal/phusion-lemp:7.3-pgsql
docker tag markkimsal/phusion-lemp:7.3.30-mssql markkimsal/phusion-lemp:7.3-mssql
