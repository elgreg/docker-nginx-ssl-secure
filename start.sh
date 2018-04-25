#!/bin/bash

# TODO: Add --add-host="localhost:192.168.65.1"
# TODO: document nginx -s reload to pick up config changes
# TODO: Start I used
# docker build --no-cache -telgreg/nginx-ssl:latest .
# docker run --add-host="localhost:192.168.65.1" -p 80:80 -p 443:443 -v ~/dev/docker-nginx-ssl-secure/etc/nginx:/etc/nginx/external -v ~/Documents/talks/caching/demo/:/usr/share/nginx/html/ elgreg/nginx-ssl:latest

# This is an example

docker run \
-p 80:80 \
-p 443:443 \
-e 'DH_SIZE=512' \
-e 'SSL_DOMAIN=local.dev.club.stuff' \
-v `pwd`/etc/nginx/:/etc/nginx/external/ \
-v `pwd`/etc/service-worker-example/:/usr/share/nginx/html/ \
elgreg/nginx-ssl:latest

