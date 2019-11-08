## Build Standard AMD64 Container
FROM alpine:3

ARG KEEPALIVED_VERSION=2.0.19
ARG KEEPALIVED_URL=https://www.keepalived.org/software/keepalived-${KEEPALIVED_VERSION}.tar.gz

# hadolint ignore=DL3003,DL3017,DL3018
RUN apk upgrade --no-cache --update && \
    apk add --no-cache ipset libnl3 openssl iptables libnfnetlink gettext tini && \
    apk add --no-cache --virtual .build-deps curl gcc make musl-dev ipset-dev libnl3-dev openssl-dev iptables-dev libnfnetlink-dev && \
    curl -k -o /tmp/keepalive.tar.gz "${KEEPALIVED_URL}" && \
    tar -zxvf /tmp/keepalive.tar.gz -C /tmp && \
    cd "/tmp/keepalived-${KEEPALIVED_VERSION}" && \
    ./configure && \
    make -j4 && \
    make install && \
    cd /tmp && \
    rm -rf "keepalived-${KEEPALIVED_VERSION}" /tmp/keepalive.tar.gz && \
    apk del .build-deps

COPY config/keepalived.conf.template /etc/keepalived/
COPY config/start.sh /usr/local/bin/
RUN chmod 0755 /usr/local/bin/start.sh

ENTRYPOINT ["tini", "--"]
CMD ["/usr/local/bin/start.sh"]
