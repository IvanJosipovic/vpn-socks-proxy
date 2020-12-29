FROM alpine:latest
LABEL org.opencontainers.image.source https://github.com/IvanJosipovic/vpn-socks-proxy

EXPOSE 1080

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
	apk add -q --progress --no-cache --update openvpn dante-server wget ca-certificates unzip curl && \
	wget -q https://www.privateinternetaccess.com/openvpn/openvpn.zip -O /pia.zip && \
	wget -q https://www.ipvanish.com/software/configs/configs.zip -O /ipvanish.zip && \
	mkdir -p /openvpn/ && \
	unzip -q pia.zip -d /openvpn/pia && \
	unzip -q ipvanish.zip -d /openvpn/ipvanish && \
	mkdir -p /openvpn/ghostpath && \
	wget -q https://ghostpath.com/servers/filegen/yul1.gpvpn.com/o -O /openvpn/ghostpath/yul1.ovpn && \
	wget -q https://ghostpath.com/servers/filegen/yul2.gpvpn.com/o -O /openvpn/ghostpath/yul2.ovpn && \
	wget -q https://ghostpath.com/servers/filegen/yul3.gpvpn.com/o -O /openvpn/ghostpath/yul3.ovpn && \
	wget -q https://ghostpath.com/servers/filegen/yyz1.gpvpn.com/o -O /openvpn/ghostpath/yyz1.ovpn && \
	wget -q https://ghostpath.com/servers/filegen/yyz2.gpvpn.com/o -O /openvpn/ghostpath/yyz2.ovpn && \
	wget -q https://ghostpath.com/servers/filegen/yvr1.gpvpn.com/o -O /openvpn/ghostpath/yvr1.ovpn && \
	apk del -q --progress --purge unzip wget && \
	rm -rf /*.zip /var/cache/apk/*

COPY ./app/ /app
COPY ./etc/ /etc

RUN chmod 500 /app/ovpn/run /app/init.sh /app/down.sh

RUN echo 'nameserver 1.1.1.1' > /etc/resolv.conf

ENV FILTER="" \
	SHUFFLE="" \
	CONFIG="" \
	WORKING_DIR=""

CMD ["/app/ovpn/run"]
