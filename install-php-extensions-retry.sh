#!/bin/sh
# Wrapper around install-php-extensions that retries failed installs.
# PECL (pecl.php.net) occasionally responds with HTTP 5xx under load and
# `pecl install` has no retry of its own, so we retry the whole install.

max_attempts="${IPE_RETRY_ATTEMPTS:-5}"
delay="${IPE_RETRY_DELAY:-30}"
attempt=1

until install-php-extensions.orig "$@"; do
    if [ "$attempt" -ge "$max_attempts" ]; then
        echo "install-php-extensions $* failed after $attempt attempts" >&2
        exit 1
    fi
    wait=$((attempt * delay))
    echo "install-php-extensions $* failed (attempt $attempt/$max_attempts), retrying in ${wait}s..." >&2
    sleep "$wait"
    attempt=$((attempt + 1))
done
