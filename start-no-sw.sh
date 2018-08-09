#!/bin/bash

# docker build --no-cache -telgreg/nginx-ssl:latest .

# This is an example

# I use this to generate my local mac's IP. Comment out if you'd like. Comes in handy
export DOCKER_FOR_MAC_IP=`docker run alpine ping -n -q -c 1 docker.for.mac.localhost | grep -o -E  [0-9^/]+\.[0-9^/]+\.[0-9^/]+\.[0-9^/]+ | head -n 1 | xargs echo -n`;

docker run \
-p 80:80 \
-p 443:443 \
-e 'DH_SIZE=512' \
-e 'SSL_DOMAIN=local.dev.club.stuff' \
--add-host="mac.local:$DOCKER_FOR_MAC_IP" \
-v `pwd`/etc/nginx/:/etc/nginx/external/ \
-v `pwd`/etc/service-worker-example/:/usr/share/nginx/html/ \
elgreg/nginx-ssl:latest

