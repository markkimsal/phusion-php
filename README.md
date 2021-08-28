Nginx + PHP + Build Tools + Supervisor
===
phusion lemp server uses runit for a tiny supervisor.

phusion lemp server uses Debian Buster for compatibility with MSSQL drivers.

phusion lemp server separates build tools into a separate image for your CI pipeline.


```
sh ./make-73.sh
sh ./make-80.sh
```

Official PHP docker image combined with phusion/baseimage to get cron, syslog, runit, and nginx

Builder variant now has nvm 0.38.0 and nodejs 14.x.

MSSQL image now with pdo_sqlsrv and pdo_dblib.

All images have intl extension because `money_format()` is going away.

All images have gd, because maybe you need to make some user initial icons.

All images have mysql, because, yeah, you probably need to connect to some DB, and also mysql

All images have sqlite3, readline, memcached, and igbinary (as of 7.3.26)

All images have xdebug extension available, but not enabled by default.  (use `-d zend_extension=xdebug.so` to enable per run (as of 7.3.26))

All images have zip, ZipArchive, and SOAP extension available (as of 7.3.26)

All images have SSH2 extension available (as of 7.3.26)

All images have BCMATH extension available (as of 7.3.26)

|PHP Version - flavor |  7.3.28-fpm |  7.3.28-builder | 8.0.7-fpm | 8.0.7-builder |
|----------|----------|-----------------|-----|-----|
| BCMATH               | X |  X | X |  X |
| Intl                 | X |  X | X |  X |
| gd                   | X |  X | X |  X |
| mysql                | X |  X | X |  X |
| pgsql                | X |  X | X |  X |
| mssql                | X |  X | X |  X |
| dblib                | X |  X | X |  X |
| sqlite3              | X |  X | X |  X |
| readline             | X |  X | X |  X |
| memcached (igbinary) | X |  X | X |  X |
| xdebug               | X |  X | X |  X |
| zip                  | X |  X | X |  X |
| SOAP                 | X |  X | X |  X |
| SSH2                 | X |  X | X |  X |
| pcntl                | X |  X | X |  X |
| nginx                | X |  X | X |  X |
| yarn                 |   |  X |   |  X |
| nodejs-14.x          |   |  X |   |  X |
| composer2            |   |  X |   |  X |
| composer1.10         |   |  X |   |  X |
| deployer             |   |  X |   |  X |
| altax                |   |  X |   |  X |
| git                  |   |  X |   |  X |

## PHP extension installation

You can install extension just like the "official" php docker container

```
FROM markkimsal/phuion-lemp:7.3.26-fpm-buster

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

