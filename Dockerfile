FROM phusion/baseimage:0.10.0

#ENV BTC_VERSION latest in ppa
RUN mkdir -p /root/.bitcoin
VOLUME /root/.bitcoin
ENV OPT_ZMQ="-zmqpubrawblock=tcp://0.0.0.0:8331 -zmqpubrawtx=tcp://0.0.0.0:8331 -zmqpubhashtx=tcp://0.0.0.0:8331 -zmqpubhashblock=tcp://0.0.0.0:8331"

RUN add-apt-repository ppa:bitcoin/bitcoin && \
    apt-get update && \
    apt-get install -y bitcoin

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/sbin/my_init", "--","bitcoind"]
CMD ['-conf="/root/.bitcoin/bitcoin.conf"', '-datadir="/root/.bitcoin"',$OPT_ZMQ]
EXPOSE 8333 18333 8332 18332 8331 18331
