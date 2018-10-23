#!/bin/sh

cat <<EOF
Welcome to the slate/nginx-ssl-secure container, based
on the marvambass/nginx-ssl-secure container

IMPORTANT:
  IF you use SSL inside your personal NGINX-config,
  you should add the Strict-Transport-Security header like:

    # only this domain
    add_header Strict-Transport-Security "max-age=31536000";
    # apply also on subdomains
    add_header Strict-Transport-Security "max-age=31536000; includeSubdomains";

  to your config.
  After this you should gain a A+ Grade on the Qualys SSL Test

EOF

if [ -z ${DH_SIZE+x} ]
then
  >&2 echo ">> no \$DH_SIZE specified using default"
  DH_SIZE="2048"
fi


DH="/etc/nginx/external/dh.pem"

if [ ! -e "$DH" ]
then
  echo ">> seems like the first start of nginx"
  echo ">> doing some preparations..."
  echo ""

  echo ">> generating $DH with size: $DH_SIZE"
  openssl dhparam -out "$DH" $DH_SIZE
fi


if [ -z "${SSL_DOMAIN}" ]
then
  >&2 echo ">> no \$SSL_DOMAIN specified using default local.dev.club.stuff"
  SSL_DOMAIN="local.dev.club.stuff"
fi

echo "running minica for ${SSL_DOMAIN}"

cd /etc/nginx/external

/opt/minica --domains "$SSL_DOMAIN"


# if [ ! -e "/etc/nginx/external/cert.pem" ] || [ ! -e "/etc/nginx/external/key.pem" ]
# then
#   echo ">> generating self signed cert"
#   openssl req -x509 -newkey rsa:4086 \
#   -subj "/C=XX/ST=XXXX/L=XXXX/O=XXXX/CN=${SSL_DOMAIN}" \
#   -ca
#   -keyout "/etc/nginx/external/key.pem" \
#   -out "/etc/nginx/external/cert.pem" \
#   -days 3650 -nodes -sha256
# fi


# Create base localhost.conf if none exists
if [ ! -e "/etc/nginx/external/localhost.conf" ]
then
echo ">> No localhost.conf specified. Generating one for ${SSL_DOMAIN}"
cat >/etc/nginx/external/localhost.conf <<EOF

server {
	listen 80 default_server;
	listen [::]:80 default_server;
	server_name ${SSL_DOMAIN};
	return 301 https://$host$request_uri;
}

server {

  listen 443 ssl;
  server_name ${SSL_DOMAIN};

  add_header Strict-Transport-Security "max-age=31536000; includeSubdomains";

  # Change servername here
  ssl_certificate /etc/nginx/external/${SSL_DOMAIN}/cert.pem;
  ssl_certificate_key /etc/nginx/external/${SSL_DOMAIN}/key.pem;

  root /usr/share/nginx/html/;

  location / {
    autoindex on;
    try_files \$uri \$uri/index.html =404;
  }

}

EOF
fi


echo ">> copy /etc/nginx/external/*.conf files to /etc/nginx/conf.d/"
cp /etc/nginx/external/*.conf /etc/nginx/conf.d/ 2> /dev/null > /dev/null


cat <<EOF

This script generated a new root certificate called minica
in whatever folder you specified to moun to /etc/nginx/external.

To use it and get secure local ssl (i.e. for testing services workers),
you will need to install it in your OS. On Mac run:

sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain minica.pem

EOF

# exec CMD
echo ">> exec docker CMD"
echo "$@"
exec "$@"
