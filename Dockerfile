FROM debian:bookworm-slim

# PHP 7.4 is EOL and the official php:7.4 image is no longer updated, so PHP
# comes from the Sury repository, which still ships backported security fixes.
# The layout mimics the official image (PHP_INI_DIR, php-fpm.d, php-fpm binary).

ENV PHP_INI_DIR=/usr/local/etc/php
ENV PHP_POOL_DIR=/usr/local/etc/php-fpm.d

RUN apt-get update -y && apt-get install --no-install-recommends --no-install-suggests -y \
    ca-certificates \
    curl \
    lsb-release && \
    curl -fsSL --retry 5 -o /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb && \
    dpkg -i /tmp/debsuryorg-archive-keyring.deb && \
    rm /tmp/debsuryorg-archive-keyring.deb && \
    echo "deb [signed-by=/usr/share/keyrings/debsuryorg-archive-keyring.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" \
        > /etc/apt/sources.list.d/php.list && \
    apt-get update -y && apt-get install --no-install-recommends --no-install-suggests -y \
    php7.4-cli \
    php7.4-fpm \
    php7.4-bcmath \
    php7.4-bz2 \
    php7.4-curl \
    php7.4-gd \
    php7.4-gnupg \
    php7.4-http \
    php7.4-propro \
    php7.4-raphf \
    php7.4-imagick \
    php7.4-imap \
    php7.4-intl \
    php7.4-mbstring \
    php7.4-mcrypt \
    php7.4-mysql \
    php7.4-opcache \
    php7.4-readline \
    php7.4-redis \
    php7.4-soap \
    php7.4-sqlite3 \
    php7.4-ssh2 \
    php7.4-xml \
    php7.4-yaml \
    php7.4-zip && \
    rm -rf /var/lib/apt/lists/*

# Extensions not packaged by Sury are built from source (PECL / php-src)
COPY ./docker/install-extension.sh /usr/local/bin/install-extension

RUN apt-get update -y && apt-get install --no-install-recommends --no-install-suggests -y \
    build-essential \
    pkg-config \
    php7.4-dev \
    unzip \
    xz-utils \
    libaio1 \
    libvips42 \
    libvips-dev \
    libzstd1 \
    libzstd-dev && \
    apt-mark manual libaio1 libvips42 libzstd1 && \
    # libmpdec (needed by decimal) is not packaged in Debian 12
    mkdir /tmp/mpdecimal && \
    curl -fsSL --retry 5 https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-2.5.1.tar.gz \
        | tar -xz -C /tmp/mpdecimal --strip-components=1 && \
    (cd /tmp/mpdecimal && ./configure --disable-cxx && make -j"$(nproc)" && make install) && \
    rm -rf /tmp/mpdecimal && \
    ldconfig && \
    # Oracle Instant Client for oci8 / pdo_oci
    case "$(dpkg --print-architecture)" in \
        arm64) \
            IC_VERSION=19.10; \
            IC_URL=https://download.oracle.com/otn_software/linux/instantclient/191000/instantclient-basiclite-linux.arm64-19.10.0.0.0dbru.zip; \
            IC_SDK_URL=https://download.oracle.com/otn_software/linux/instantclient/191000/instantclient-sdk-linux.arm64-19.10.0.0.0dbru.zip ;; \
        amd64) \
            IC_VERSION=21.1; \
            IC_URL=https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-basiclite-linux.x64-21.1.0.0.0.zip; \
            IC_SDK_URL=https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sdk-linux.x64-21.1.0.0.0.zip ;; \
        *) \
            echo "Unsupported architecture for Oracle Instant Client: $(dpkg --print-architecture)" >&2; \
            exit 1 ;; \
    esac && \
    IC_DIR=/usr/lib/oracle/$IC_VERSION/client64/lib && \
    curl -fsSL --retry 5 -o /tmp/ic.zip "$IC_URL" && \
    curl -fsSL --retry 5 -o /tmp/ic-sdk.zip "$IC_SDK_URL" && \
    mkdir -p /tmp/ic && unzip -q /tmp/ic.zip -d /tmp/ic && unzip -q /tmp/ic-sdk.zip -d /tmp/ic && \
    mkdir -p "$(dirname "$IC_DIR")" && mv /tmp/ic/instantclient_* "$IC_DIR" && \
    rm -rf /tmp/ic /tmp/ic.zip /tmp/ic-sdk.zip && \
    echo "$IC_DIR" > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig && \
    # oci8 and pdo_oci are still bundled with PHP 7.4
    mkdir /tmp/php-src && \
    curl -fsSL --retry 5 https://github.com/php/php-src/archive/refs/tags/php-7.4.33.tar.gz \
        | tar -xz -C /tmp/php-src --strip-components=1 && \
    install-extension oci8 /tmp/php-src/ext/oci8 --with-oci8=instantclient,$IC_DIR && \
    install-extension pdo_oci /tmp/php-src/ext/pdo_oci --with-pdo-oci=instantclient,$IC_DIR && \
    rm -rf /tmp/php-src && \
    install-extension csv https://pecl.php.net/get/CSV-0.3.1.tgz && \
    install-extension decimal https://pecl.php.net/get/decimal-1.5.1.tgz && \
    install-extension geospatial https://pecl.php.net/get/geospatial-0.3.2.tgz && \
    install-extension inotify https://pecl.php.net/get/inotify-3.0.0.tgz && \
    install-extension vips https://pecl.php.net/get/vips-1.0.13.tgz && \
    install-extension zstd https://pecl.php.net/get/zstd --with-libzstd && \
    apt-get purge -y --auto-remove \
        build-essential \
        pkg-config \
        php7.4-dev \
        libvips-dev \
        libzstd-dev && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && apt-get install --no-install-recommends --no-install-suggests -y \
    curl \
    git \
    ghostscript \
    jq \
    libfcgi-bin \
    poppler-utils \
    ssh \
    unzip \
    zip \
    xz-utils \
    libvips-tools \
    imagemagick && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN curl https://rclone.org/install.sh | bash
RUN rclone config touch && \
    mkdir -p /var/www && \
    cp /root/.config/rclone/rclone.conf /var/www/.rclone.conf && \
    chown www-data:www-data /var/www/.rclone.conf

# Official image layout: one php.ini + conf.d shared by CLI and FPM, pools in php-fpm.d
RUN rm -rf /etc/php/7.4/cli/conf.d /etc/php/7.4/cli/php.ini && \
    ln -s ../fpm/conf.d /etc/php/7.4/cli/conf.d && \
    ln -s ../fpm/php.ini /etc/php/7.4/cli/php.ini && \
    ln -s /etc/php/7.4/fpm "$PHP_INI_DIR" && \
    rm -f /etc/php/7.4/fpm/pool.d/* && \
    ln -s /etc/php/7.4/fpm/pool.d "$PHP_POOL_DIR" && \
    ln -s /etc/php/7.4/fpm/php-fpm.conf /usr/local/etc/php-fpm.conf && \
    ln -s /usr/sbin/php-fpm7.4 /usr/local/sbin/php-fpm && \
    mkdir -p /var/www/html && \
    chown www-data:www-data /var/www/html && \
    chmod 1777 /var/www/html

COPY ./docker/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf
COPY ./docker/docker.conf ./docker/zz-docker.conf /etc/php/7.4/fpm/pool.d/
COPY ./docker/docker-php-entrypoint /usr/local/bin/
COPY ./custom.ini /etc/php/7.4/fpm/conf.d/xy-custom.ini
COPY ./pools/* /etc/php/7.4/fpm/pool.d/

USER www-data

# Fail the build if a dependency pulled in another PHP version or an extension is missing
RUN test "$(php -r 'echo PHP_MAJOR_VERSION . "." . PHP_MINOR_VERSION;')" = "7.4" && \
    ! ls /usr/bin/php8* >/dev/null 2>&1 && \
    for module in bcmath bz2 calendar csv decimal exif gd geospatial gettext gnupg http imagick imap inotify intl \
        mcrypt mysqli oci8 pdo_mysql PDO_OCI raphf redis soap sockets ssh2 vips yaml zip zstd "Zend OPcache"; do \
        php -m | grep -qx "$module" || { echo "Missing PHP module: $module" >&2; exit 1; }; \
    done && \
    php-fpm -t

# Oracle support is critical: make sure the Instant Client libraries resolve and that both
# oci8 and PDO_OCI actually reach the Oracle network layer (ORA-12xxx = no listener, as expected)
RUN extension_dir="$(php -r 'echo ini_get("extension_dir");')" && \
    for so in oci8 pdo_oci; do \
        if ldd "$extension_dir/$so.so" | grep 'not found'; then \
            echo "Unresolved libraries for $so.so" >&2; exit 1; \
        fi; \
    done && \
    php -r '@oci_connect("u", "p", "//127.0.0.1:1/x"); $e = oci_error(); echo $e["message"];' | tee /dev/stderr | grep -q 'ORA-12' && \
    php -r 'try { new PDO("oci:dbname=//127.0.0.1:1/x", "u", "p"); } catch (PDOException $e) { echo $e->getMessage(); }' | tee /dev/stderr | grep -q 'ORA-12'

WORKDIR /var/www/html

ENTRYPOINT ["docker-php-entrypoint"]
STOPSIGNAL SIGQUIT

EXPOSE 9000
EXPOSE 9001

CMD ["php-fpm"]
