FROM alpine:latest
LABEL org.opencontainers.image.source https://github.com/IvanJosipovic/vpn-socks-proxy

EXPOSE 1080

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
	apk add -q --progress --no-cache --update openvpn dante-server wget ca-certificates unzip && \
	wget -q https://www.privateinternetaccess.com/openvpn/openvpn.zip \
			https://www.ipvanish.com/software/configs/configs.zip && \
	mkdir -p /openvpn/ && \
	unzip -q openvpn.zip -d /openvpn/pia && \
	unzip -q configs.zip -d /openvpn/ipvanish && \
	apk del -q --progress --purge unzip wget && \
	rm -rf /*.zip /var/cache/apk/*

COPY ./app/ /app
COPY ./etc/ /etc

RUN chmod 500 /app/ovpn/run /app/init.sh

RUN echo 'nameserver 1.1.1.1' > /etc/resolv.conf

ENV FILTER="" \
	SHUFFLE="" \
	CONFIG=""

CMD ["/app/ovpn/run"]
