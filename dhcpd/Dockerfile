FROM alpine:3.10.1

ARG DHCP_GID=666
ARG DHCP_UID=666

RUN set -x \
      && addgroup -S -g ${DHCP_GID} dhcp \
      && adduser -S -u ${DHCP_UID} -G dhcp dhcp \
      && apk add --no-cache dhcp \
      && chown -R dhcp:dhcp \
            /etc/dhcp/ \
            /var/lib/dhcp/

EXPOSE 67/udp 67/tcp
VOLUME /etc/dhcp /var/lib/dhcp
CMD ["/usr/sbin/dhcpd", "-user", "dhcp", "-4", "-f", "-d", "--no-pid", "-cf", "/etc/dhcp/dhcpd.conf", "-lf", "/var/lib/dhcp/dhcpd.leases"]
