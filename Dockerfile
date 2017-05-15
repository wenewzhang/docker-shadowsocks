FROM ubuntu:16.04
MAINTAINER JinnLynn <eatfishlin@gmail.com>

ARG SS_VER=3.0.6
ARG SS_URL=https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_VER/shadowsocks-libev-$SS_VER.tar.gz

ENV SS_ADDR     0.0.0.0
ENV SS_PORT     8388
ENV SS_PWD=
ENV SS_METHOD   aes-256-cfb
ENV SS_TIMEOUT  300
ENV SS_DNS      8.8.8.8
ENV SS_DNS2     8.8.4.4

ENV BASEDIR /tmp/work
ENV BUILD_DEPS curl ca-certificates build-essential autoconf libtool automake
ENV RUN_DEPS libev-dev libudns-dev libpcre3-dev libmbedtls-dev libsodium-dev

WORKDIR $BASEDIR

RUN apt-get update \
    && apt-get install --no-install-recommends -y $BUILD_DEPS $RUN_DEPS

RUN curl -sSL "$SS_URL" | tar xz \
    && cd shadowsocks-libev* \
    && ./configure --prefix=/usr --disable-documentation \
    && make \
    && make install

WORKDIR /
RUN rm -rf $BASEDIR \
    && apt-get autoremove --purge -y $BUILD_DEPS \
    && apt-get clean -y

EXPOSE $SS_PORT/tcp $SS_PORT/udp

CMD SS_VER=$(ss-server -h | head -n 2 | grep shadowsocks-libev | awk '{print $2}') \
    && SS_PWD=${SS_PWD:-$(head -n 5 /dev/urandom | md5sum | head -c 8)} \
    && echo "===============================================" \
    && echo "Shadowsocks is now ready for use!              " \
    && echo "                                               " \
    && echo "VERSION:   $SS_VER                             " \
    && echo "SERVER IP: $SS_ADDR                            " \
    && echo "PORT:      $SS_PORT                            " \
    && echo "PASSWORD:  $SS_PWD                             " \
    && echo "METHOD:    $SS_METHOD                          " \
    && echo "TIMEOUT:   $SS_TIMEOUT                         " \
    && echo "DNS:       $SS_DNS, $SS_DNS2                   " \
    && echo "===============================================" \
    ss-server -s $SS_ADDR \
              -p $SS_PORT \
              -k $SS_PWD \
              -m $SS_METHOD \
              -t $SS_TIMEOUT \
              -d $SS_DNS \
              -d $SS_DNS2 \
              --fast-open \
              -u
