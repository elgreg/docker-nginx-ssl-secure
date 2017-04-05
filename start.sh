#!/bin/bash

docker run \
-p 80:80 -p 443:443 \
-e 'DH_SIZE=512' \
-v `pwd`/etc/nginx/:/etc/nginx/external/ \
nginx-ssl:latest