```
docker build -t markkimsal/phusion-lemp:7.3.14-mssql -f ./Dockerfile-mssql .
docker build -t markkimsal/phusion-lemp:7.3.14-pgsql -f ./Dockerfile-pgsql .
docker build -t markkimsal/phusion-lemp:7.3.14-mysql -f ./Dockerfile-mysql .
```

Official PHP docker image combined with phusion/baseimage to get cron, syslog, runit, and nginx


## PHP extension installation

You can install extension just like the "official" php docker container

```
FROM markkimsal/php:7.3.14-fpm-buster

RUN docker-php-ext-install mysqli pdo_mysql \
    && docker-php-ext-enable mysqli pdo_mysql
```


## Nginx Vhost Sample

Pass PHP requests to localhost 9000.  This assumes everything is copied or mounted to `/app`

```
map $http_x_forwarded_proto $fastcgi_param_https_variable {
  default '';
  https 'on';
}

server {
  listen 0.0.0.0:8080 default;
  server_name _;

  root /app/public;
  index index.php index.html index.htm;

  location / {
    try_files $uri $uri/ /index.php?$args;
    #try_files $uri $uri/index.php;
  }

  location ~ \.php$ {
    fastcgi_pass localhost:9000;
    include fastcgi.conf;

    fastcgi_index /index.php;

    fastcgi_param HTTPS $fastcgi_param_https_variable;
    fastcgi_param PATH_INFO $fastcgi_path_info;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_param SCRIPT_NAME $fastcgi_script_name;
  }
}
```

Docker-compose example
```
services:
  webapp:
    tty: true
    build:
      context: ./
      dockerfile: ci/dockerfile-phpfpm
    ports:
      - 8080:8080
    volumes:
      - .:/app
      - ./config/container-nginx.vhost.conf:/etc/nginx/conf.d/container-vhost.conf
```


## MSSQL Sqlsrv extension
Mssql gives .deb packages for installing ODBC and sqlsrv extension on PHP.  This means you need Debian/Ubuntu instead of alpine.
```
FROM markkimsal/php-nginx-phusion:7.3-fpm

# Add Microsoft repo for Microsoft ODBC Driver 13 for Linux
RUN apt-get update \
    && apt-get install -y apt-utils gnupg curl build-essential libaio1 software-properties-common locales iputils-ping --no-install-recommends \
    && apt-get install -y \
    apt-transport-https \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update

# Install Dependencies
RUN ACCEPT_EULA=Y apt-get install -y \
    unixodbc \
    unixodbc-dev \
    libgss3 \
    odbcinst \
    msodbcsql17 \
    locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

# Install pdo_sqlsrv and sqlsrv from PECL. Replace pdo_sqlsrv-4.1.8preview with preferred version.
RUN pecl install pdo_sqlsrv sqlsrv \
    && docker-php-ext-enable pdo_sqlsrv sqlsrv
```

