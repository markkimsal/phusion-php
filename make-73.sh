docker build -t markkimsal/phusion-lemp:7.3.26-mssql -f ./Dockerfile-mssql . 
docker build -t markkimsal/phusion-lemp:7.3.26-pgsql -f ./Dockerfile-pgsql . 
docker build -t markkimsal/phusion-lemp:7.3.26-mysql -f ./Dockerfile-mysql . 
docker build -t markkimsal/phusion-lemp:7.3.26-builder -f ./Dockerfile-builder . 
