#!/bin/bash

echo "Building without own certificate authority."

docker run \
-p 80:80 \
-p 443:443 \
-e 'DH_SIZE=512' \
-e 'SSL_DOMAIN=local.dev.club.stuff' \
-v `pwd`/etc/nginx/:/etc/nginx/external/ \
-v `pwd`/etc/service-worker-example/:/usr/share/nginx/html/ \
elgreg/nginx-ssl:latest

