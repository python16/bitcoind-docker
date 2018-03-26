FROM phusion/baseimage:0.10.0

ENV BTC_VERSION 0.16.0
RUN mkdir -p /root/.bitcoin
VOLUME /root/.bitcoin
ENV OPT_ZMQ="-zmqpubrawblock=tcp://0.0.0.0:8331 -zmqpubrawtx=tcp://0.0.0.0:8331 -zmqpubhashtx=tcp://0.0.0.0:8331 -zmqpubhashblock=tcp://0.0.0.0:8331"

RUN apt-get update && \
    apt-get install -y build-essential wget curl net-tools libtool autotools-dev \
    automake pkg-config libssl-dev libevent-dev bsdmainutils \
    libboost-system-dev libboost-filesystem-dev libboost-chrono-dev \
    libboost-program-options-dev libboost-test-dev libboost-thread-dev libzmq3-dev && \
    mkdir ~/source && \
    cd ~/source && \
    wget https://github.com/python16/bitcoin/archive/v${BTC_VERSION}.tar.gz && \
    tar zxf v${BTC_VERSION}.tar.gz && \
    cd bitcoin-${BTC_VERSION} && \
    ./autogen.sh && \
    ./configure --disable-wallet --disable-tests && \
    make && make install && \
    apt-get remove -y build-essential wget curl net-tools libtool autotools-dev \
    automake pkg-config && \
    apt-get autoremove -y && rm -rf ~/source && rm -rf /usr/include/boost && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/sbin/my_init", "--"]
CMD ["bitcoind","-conf='/root/.bitcoin/bitcoin.conf'", "-datadir='/root/.bitcoin'",$OPT_ZMQ]
EXPOSE 8333 18333 8332 18332 8331 18331
