FROM ubuntu:14.04
LABEL MAINTAINER="Greg Junge <gj8287@att.com>"

COPY rootfs/ /.

## Install project requirements
RUN set -x \
    && apt-get update \
    && apt-get install -y bash dnsutils nmap openssh-client openssh-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/run/sshd \
    && passwd -d root 

CMD ["/usr/sbin/sshd", "-Dep", "22"]
