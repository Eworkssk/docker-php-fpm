# PHP FPM Docker Image

![Docker Stars](https://img.shields.io/docker/stars/eworkssk/php-fpm?style=for-the-badge)
![Docker Pulls](https://img.shields.io/docker/pulls/eworkssk/php-fpm?style=for-the-badge)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/eworkssk/php-fpm/8.5?style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/eworkssk/php-fpm/8.5?label=PHP%20Version&style=for-the-badge)

**Automatic weekly updates**

⚡ PHP 7.4, 8.1, 8.2, 8.3, 8.4 and 8.5 now available for both `linux/amd64` and `linux/arm64/v8`

💡 Do you need PHP CLI instead? Check out our [eworkssk/php-cli](https://github.com/Eworkssk/docker-php-cli) image

## Pull
```
docker pull eworkssk/php-fpm:latest
```
or for specific PHP version:
```
docker pull eworkssk/php-fpm:8.5
```

## Usage
Mount your web application anywhere and expose ports:
```
docker run -v /my-app:/my-app -p 9000:9000 -p 9001:9001 --rm eworkssk/php-fpm
```

## Configuration
PHP configuration located at `/usr/local/etc/php/`
PHP-FPM configuration located at `/usr/local/etc/php-fpm.d`

## Exposed ports
- `9000`: PHP-FPM server
- `9001`: PHP-FPM server status

## List of installed PHP extensions
```
[PHP Modules]
bcmath
bz2
calendar
cgi-fcgi
Core
csv
ctype
curl
date
decimal
dom
exif
fileinfo
filter
gd
geospatial
gettext
gnupg
hash
http
iconv
imagick
imap
intl
json
lexbor
libxml
mbstring
mysqli
mysqlnd
oci8
openssl
pcntl
pcre
PDO
pdo_mysql
PDO_OCI
pdo_sqlite
Phar
posix
random
raphf
readline
redis
Reflection
session
SimpleXML
soap
sockets
sodium
SPL
sqlite3
ssh2
standard
tokenizer
uri
vips
xml
xmlreader
xmlwriter
yaml
Zend OPcache
zip
zlib

[Zend Modules]
Zend OPcache
```

## List of installed additional software
```
curl
git
ghostscript
jq
poppler-utils
rclone
ssh
unzip
libvips
zip
xz-utils
```
