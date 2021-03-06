FROM ubuntu:14.04
LABEL MAINTAINER="Greg Junge <gj8287@att.com>"

## Install project requirements
RUN set -x \
    && apt-get update \
    && apt-get install -y \
    bash dnsutils nmap telnet \
    socat openssh-client openssh-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/run/sshd \
    && passwd -d root 

COPY rootfs/ /.

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-Dep", "22"]
