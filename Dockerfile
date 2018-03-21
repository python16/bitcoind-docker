FROM phusion/baseimage:0.10.0

ENV BTC_VERSION 0.16.0
RUN mkdir -p /root/.bitcoin
VOLUME /root/.bitcoin

RUN apt-get update && \
    apt-get install -y build-essential libtool autotools-dev \
    automake pkg-config libssl-dev libevent-dev bsdmainutils python3 \
    libboost-all-dev libzmq3-dev curl wget net-tools && \
    mkdir ~/source && \
    cd ~/source && \
    wget https://github.com/python16/bitcoin/archive/v${BTC_VERSION}.tar.gz && \
    tar zxf v${BTC_VERSION}.tar.gz && \
    cd bitcoin-${BTC_VERSION} && \
    ./autogen.sh && \
    ./configure --disable-wallet --disable-tests && \
    make && make install

RUN rm -rf ~/source

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/sbin/my_init", "--"]
CMD ["bitcoind",""]
