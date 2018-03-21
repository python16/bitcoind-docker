FROM phusion/baseimage:0.10.0

#ENV BTC_VERSION latest in ppa
RUN mkdir -p /root/.bitcoin
VOLUME /root/.bitcoin

RUN add-apt-repository ppa:bitcoin/bitcoin && \
    apt-get update && \
    apt-get install -y bitcoin

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/sbin/my_init", "--"]
CMD ["bitcoind",""]
