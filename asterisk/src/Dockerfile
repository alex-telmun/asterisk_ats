FROM debian:stretch-slim

ARG ASTERISK_VERSION="16.5.0"
ARG APT_OPTIONS="--no-install-recommends --no-install-suggests -y --force-yes "
ARG ASTERISK_UID=666
ARG ASTERISK_GID=666

COPY entrypoint.sh /

RUN set -x \
      && chmod +x /entrypoint.sh \
      && groupadd -r -g ${ASTERISK_GID} asterisk \
      && useradd -r -u ${ASTERISK_UID} -g asterisk asterisk \
      && apt-get update \
      && apt-get install ${APT_OPTIONS} \
            autoconf \
            curl \
            build-essential \
            ca-certificates \
            procps \
            unixodbc \
            unixodbc-bin \
            odbcinst \
            uuid \
            xmlstarlet \
            file \
            binutils-dev \
            libcurl4-openssl-dev \
            libedit-dev \
            libgsm1-dev \
            libogg-dev \
            libpopt-dev \
            libresample1-dev \
            libspandsp-dev \
            libspeex-dev \
            libspeexdsp-dev \
            libsqlite3-dev \
            libsrtp0-dev \
            libssl-dev \
            libvorbis-dev \
            libxml2-dev \
            libxslt1-dev \
            portaudio19-dev \
            unixodbc-dev \
            uuid-dev \
      && apt-get purge -y --auto-remove \
      && rm -rf /var/lib/apt/lists/* \
      && mkdir -p /usr/src/asterisk \
      && cd /usr/src/asterisk \
      && curl -vsL http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-${ASTERISK_VERSION}.tar.gz | tar --strip-components 1 -xz \
      && ./configure \
            --with-resample \
            --with-pjproject-bundled \
            --with-jansson-bundled \
      && make menuselect.makeopts \
      && menuselect/menuselect \
            --disable BUILD_NATIVE \
            --disable-category MENUSELECT_EXTRA_SOUNDS \
            --disable-category MENUSELECT_MOH \
            --enable CORE-SOUNDS-RU-ULAW \
            --enable CORE-SOUNDS-RU-ALAW \
            --enable CORE-SOUNDS-EN-ULAW \
            --enable CORE-SOUNDS-EN-ALAW \
            menuselect.makeopts \
      && make -j`proc` all \
      && make install \
      && make samples \
      && sed -i -E 's/^;(run)(user|group)/\1\2/' /etc/asterisk/asterisk.conf \
      && mkdir -p /etc/asterisk \
            /var/spool/asterisk/fax \
      && chown -R asterisk:asterisk /etc/asterisk \
            /var/*/asterisk \
            /usr/*/asterisk \
      && chmod -R 750 /var/spool/asterisk \
      && cd / \
      && rm -rf usr/src/asterisk \
      && DEV_PKG=$(dpkg -l | grep '\-dev' | awk '{print $2}' | xargs) \
      && apt-get --yes purge \
            autoconf \
            build-essential \
            bzip2 \
            cpp \
            m4 \
            make \
            patch \
            perl \
            perl-modules \
            pkg-config \
            xz-utils \
            ${DEV_PKG} \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /etc/asterisk/*
COPY default_config.tar.gz /
EXPOSE 5060/tcp 5060/udp
VOLUME /var/lib/asterisk/sounds /var/lib/asterisk/keys /var/lib/asterisk/phoneprov /var/spool/asterisk /var/log/asterisk /etc/asterisk
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/asterisk", "-vvvdddf", "-T", "-U", "asterisk", "-p"]
