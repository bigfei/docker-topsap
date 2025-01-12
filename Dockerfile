FROM debian:buster-slim

WORKDIR /home/work

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ENV SERVER_ADDRESS=""
ENV USER_NAME=""
ENV PASSWORD=""

# Install necessary packages and configure timezone
RUN export DEBIAN_FRONTEND=noninteractive && \
    ln -fs /usr/share/zoneinfo/Asia /etc/localtime && \
    apt-get update && \
    apt-get -y --no-install-suggests --no-install-recommends install tzdata sudo curl dante-server iproute2 ca-certificates dnsutils vim iptables procps psmisc cron iputils-ping net-tools lsof traceroute mtr-tiny && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    echo Ubuntu >> /etc/issue && \
    apt-get install -y expect && \
    if [ "$(uname -m)" = "x86_64" ]; then \
        curl -o TopSAP-3.5.2.40.2-x86_64.deb -L https://app.topsec.com.cn/linux/general/x86_64/deb/TopSAP-3.5.2.40.2-x86_64.deb; \
        dpkg -i TopSAP-3.5.2.40.2-x86_64.deb; \
        rm TopSAP-3.5.2.40.2-x86_64.deb; \
    else \
        curl -o TopSAP-3.5.2.40.2-aarch64.deb -L https://app.topsec.com.cn/linux/general/aarch64/TopSAP-3.5.2.40.2-aarch64.deb; \
        dpkg -i TopSAP-3.5.2.40.2-aarch64.deb; \
        rm TopSAP-3.5.2.40.2-aarch64.deb; \
    fi && \
    apt-get install -f -y && \
    rm -rf /var/lib/apt/lists/*

COPY start.sh .
COPY danted.conf /etc
COPY expect.exp .

EXPOSE 53/udp

CMD /home/work/start.sh
