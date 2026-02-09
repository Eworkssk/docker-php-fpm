# PHP FPM Docker Image

![Docker Stars](https://img.shields.io/docker/stars/eworkssk/php-fpm?style=for-the-badge)
![Docker Pulls](https://img.shields.io/docker/pulls/eworkssk/php-fpm?style=for-the-badge)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/eworkssk/php-fpm/8.3?style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/eworkssk/php-fpm/8.3?label=PHP%20Version&style=for-the-badge)

**Automatic weekly updates**

⚡ PHP 7.4, 8.1, 8.2 and 8.3 now available for both `linux/amd64` and `linux/arm64/v8`

💡 Do you need PHP CLI instead? Check out our [eworkssk/php-cli](https://github.com/Eworkssk/docker-php-cli) image

⚠️ PHP 7.1 build is now unsupported and weekly updates are disabled

## Pull
```
docker pull eworkssk/php-fpm:latest
```
or for specific PHP version:
```
docker pull eworkssk/php-fpm:8.3
```

## Usage
Mount your web application anywhere and expose ports:
```
docker run -v /my-app:/my-app -p 9000:9000 -p 9001:9001 --rm eworkssk/php-fpm
```

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
ftp
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
libxml
mbstring
mcrypt
mysqli
mysqlnd
oci8
openssl
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
zip
xz-utils
```
