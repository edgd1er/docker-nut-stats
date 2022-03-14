# syntax=docker/dockerfile:1
FROM debian:bullseye-slim

LABEL maintainer="edgd1er@hotmail.com"

# Expose ports.
EXPOSE 80
EXPOSE 443

ENV NAME="nut"
ENV SERVER_NAME="nut.localhost.tld"
ENV SPAWN_FCGI="/usr/bin/spawn-fcgi"
ENV DAEMON="/usr/sbin/fcgiwrap"
ENV FCGI_ADDR=127.0.0.1
ENV FCGI_PORT=9000

COPY start.sh /

# hadolint ignore=DL3008
RUN echo "Buidling nut image for $(uname -m)" && \
 apt-get update && apt-get install -y --no-install-recommends nut nut-cgi fcgiwrap nginx supervisor procps apache2-utils curl && \
 rm -r /var/lib/apt/lists/* && \
 mkdir -p /var/log/supervisor && \
 chown www-data:www-data /usr/lib/cgi-bin/nut/*.cgi && \
 chmod +x /start.sh
COPY supervisord/* /etc/supervisor/conf.d/
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY nut /etc/nginx/sites-enabled/default

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]

HEALTHCHECK --interval=60s --timeout=3s --retries=3 --start-period=40s \
 CMD curl -s -u${HT_USER}:${HT_PWD} --fail http://localhost/index.html || exit 1