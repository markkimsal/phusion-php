PHP For Local Dev, CD Pipeline, Production Deployment
===
Xdebug for local dev

Git, yarn, npm, ssh for CI/CD pipeline

Nginx, supervisor, and syslog for production


Nginx + PHP + Build Tools + Supervisor
---

phusion-php uses runit for a tiny supervisor.

phusion-php uses Debian Buster for compatibility with MSSQL drivers.

phusion-php separates build tools into a separate image for your CI pipeline.

phusion-php uses phusion/baseimage to get cron, syslog, and runit.

UID and www-data
---
You can now set the www-data user id and group id at runtime with environment variables WWWUID and WWWGID.
See 'start-container' for more details.  Inspired by laravel sail.

Usage
---
Copy the scripts/docker-compose.yml to the root of your project.

Copy the config/ and scripts/ folders to one of your projects and customize from there.


Image Details
---
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

|PHP Version - flavor |  7.3-fpm |  7.3-builder | 7.4-fpm | 7.4-builder | 8.0-fpm | 8.0-builder |
|----------|----------|-----------------|-----|-----|-----|-----|
| BCMATH               | X |  X | X | X | X |  X |
| Intl                 | X |  X | X | X | X |  X |
| gd                   | X |  X | X | X | X |  X |
| mysql                | X |  X | X | X | X |  X |
| pgsql                | X |  X | X | X | X |  X |
| mssql                | X |  X | X | X | X |  X |
| dblib                | X |  X | X | X | X |  X |
| sqlite3              | X |  X | X | X | X |  X |
| readline             | X |  X | X | X | X |  X |
| memcached (igbinary) | X |  X | X | X | X |  X |
| xdebug               | X |  X | X | X | X |  X |
| zip                  | X |  X | X | X | X |  X |
| SOAP                 | X |  X | X | X | X |  X |
| SSH2                 | X |  X | X | X | X |  X |
| pcntl                | X |  X | X | X | X |  X |
| lib sodium           | X |  X | X | X | X |  X |
| nginx                | X |  X | X | X | X |  X |
| yarn                 |   |  X |   | X |   |  X |
| nodejs-14.x          |   |  X |   | X |   |  X |
| composer2            |   |  X |   | X |   |  X |
| composer1.10         |   |  X |   | X |   |  X |
| deployer             |   |  X |   | X |   |  X |
| altax                |   |  X |   | X |   |  X |
| git                  |   |  X |   | X |   |  X |
| unzip                |   |  X |   | X |   |  X |


PHP 7.3 images have updated timezone database for 2021.  (does your distro have updated Samoan DST?)

How to Build
---

```
sh ./make-73.sh
sh ./make-74.sh
sh ./make-80.sh
```


Nginx Vhost Sample
----

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
This is already included in the phusion-php images.  This is only for historical reasons and syntax reference.


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

