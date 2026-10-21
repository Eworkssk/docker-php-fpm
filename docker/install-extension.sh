#!/bin/sh
# Builds a PHP extension from source against the Sury php7.4 packages and enables it.
# Usage: install-extension.sh <name> <tarball-url|source-dir> [configure options...]
set -eu

name="$1"
source="$2"
shift 2

work="$(mktemp -d)"
if [ -d "$source" ]; then
    cp -a "$source/." "$work"
else
    # PECL is occasionally overloaded and answers with HTTP 5xx, so retry hard
    curl -fsSL --retry 10 --retry-all-errors --retry-delay 15 "$source" \
        | tar -xz -C "$work" --strip-components=1
fi

cd "$work"
phpize7.4
./configure --with-php-config=/usr/bin/php-config7.4 "$@"
make -j"$(nproc)"
make install

printf "; priority=30\nextension=%s.so\n" "$name" > "/etc/php/7.4/mods-available/$name.ini"
phpenmod -v 7.4 "$name"

cd /
rm -rf "$work"
