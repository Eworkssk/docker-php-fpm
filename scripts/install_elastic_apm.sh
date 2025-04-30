#!/bin/sh

case $1 in
    "linux/amd64")
        wget -O /elastic_apm_agent.deb \
            https://github.com/elastic/apm-agent-php/releases/download/v$2/apm-agent-php_$2_amd64.deb
        ;;
    "linux/arm64/v8")
        wget -O /elastic_apm_agent.deb \
            https://github.com/elastic/apm-agent-php/releases/download/v$2/apm-agent-php_$2_arm64.deb
        ;;
    *)
        echo "Failed to download Elastic APM Agent for PHP. Unknown architecture: $1"
        exit 1
        ;;
esac

dpkg -i /elastic_apm_agent.deb
rm /elastic_apm_agent.deb
