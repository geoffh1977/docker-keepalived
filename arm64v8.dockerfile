### Build ARM64v8 Container (Raspberry Pi 4 Comapatible)
### Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
FROM alpine:3 AS builder
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz

# hadolint ignore=DL3018,DL3019,DL4006
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

### Build Final Container
FROM arm64v8/alpine:3

# Add QEMU
COPY --from=builder qemu-aarch64-static /usr/bin

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

COPY files/keepalived.conf.template /etc/keepalived/
COPY files/start.sh /usr/local/bin/
RUN chmod 0755 /usr/local/bin/start.sh

ENTRYPOINT ["tini", "--"]
CMD ["/usr/local/bin/start.sh"]
