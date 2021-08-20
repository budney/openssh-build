ARG RELEASE buster
ARG TAG latest
FROM navikey/raspbian-${RELEASE}:${TAG} as build
USER root

ENV REPO https://salsa.debian.org/ssh-team/openssh.git
ENV WORKDIR /root

# Install temp files
WORKDIR ${WORKDIR}
COPY rules.patch entrypoint.sh ${WORKDIR}/

# Install tons of stuff
RUN apt update && apt install -y \
    git build-essential dh-runit cmake devscripts \
    autotools-dev debhelper dh-autoreconf dh-exec dpkg-dev libaudit-dev \
    libedit-dev libgtk-3-dev libkrb5-dev libpam0g-dev libselinux1-dev \
    libssl-dev libsystemd-dev libwrap0-dev pkg-config zlib1g-dev

RUN sed -i -e "s}ROOT}${WORKDIR}}" entrypoint.sh \
    && /bin/cp -f entrypoint.sh / \
    && git clone $REPO \
    && cd openssh \
    && patch -p1 < ${WORKDIR}/rules.patch \
    && sed -i -e 's},since=.*$}}' debian/openssh-server.runit \
    && sed -i -e '/debhelper-compat/s/9/10/' debian/control \
    && autoreconf \
    && debuild -b -d -uc -us

ENTRYPONT ["/entrypoint.sh"]
