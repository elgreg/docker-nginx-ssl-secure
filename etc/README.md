minica is used to create a certificate authority for
generating your own local certs.

This script defaults to local.dev.club.stuff, but will
create a cert for whatever domain name is provied by the
SSL_DOMAIN environment variable.

minica comes via git@github.com:jsha/minica.git

It was built for go using goalpine like so:

```
cd [some dev/temp folder]
git clone git@github.com:jsha/minica.git
docker run -it -v `pwd`/minica:/opt/minica golang:alpine
# in container
cd /opt/minica
go build
```

Then copy the resulting binary into this foler and it
will be added to the build via Dockerfile.


