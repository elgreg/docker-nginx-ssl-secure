#!/bin/bash

echo "Building with certificate authority."

docker run \
-p 80:80 \
-p 443:443 \
-e 'DH_SIZE=512' \
-e 'USE_MINICA=1' \
-e 'SSL_DOMAIN=local.dev.club.stuff' \
-v `pwd`/etc/nginx/:/etc/nginx/external/ \
-v `pwd`/etc/service-worker-example/:/usr/share/nginx/html/ \
elgreg/docker-nginx-ssl-secure:latest

