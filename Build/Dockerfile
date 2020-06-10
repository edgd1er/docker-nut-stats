FROM --platform=$BUILDPLATFORM debian:buster-slim
ARG TARGETPLATFORM
ARG BUILDPLATFORM

MAINTAINER edgd1er@hotmail.com

# Expose ports.
EXPOSE 80
EXPOSE 443

ENV NAME="nut"
ENV SERVER_NAME="nut.localhost.tld"
ENV SPAWN_FCGI="/usr/bin/spawn-fcgi"
ENV DAEMON="/usr/sbin/fcgiwrap"
ENV FCGI_ADDR=127.0.0.1
ENV FCGI_PORT=9000

RUN echo "Buidling nut image for ${TARGETPLATFORM}"
RUN apt-get update && apt-get install -y nut nut-cgi fcgiwrap nginx supervisor procps apache2-utils vim; \
 rm -r /var/lib/apt/lists/* ; \
 mkdir -p /var/log/supervisor; \
 chown www-data:www-data /usr/lib/cgi-bin/nut/*.cgi
COPY start.sh /
COPY nut /etc/nginx/sites-enabled/default
COPY supervisord/fcgisock.conf /etc/supervisor/conf.d/
COPY supervisord/fcgiwrap.conf /etc/supervisor/conf.d/
COPY supervisord/nginx.conf /etc/supervisor/conf.d/
COPY supervisord/script.conf /etc/supervisor/conf.d/
COPY supervisord/supervisord.conf /etc/supervisor/supervisord.conf

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]