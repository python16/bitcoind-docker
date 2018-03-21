FROM phusion/baseimage:0.10.0

CMD ["/sbin/my_init"]

RUN apt-get update
RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3
RUN apt-get install -y libboost-all-dev libzmq3-dev curl wget net-tools

RUN mkdir ~/source \
  && cd ~/source && wget https://github.com/python16/bitcoin/archive/v0.16.0.tar.gz \
  && cd ~/source \
  && tar zxf v0.16.0.tar.gz && cd bitcoin-0.16.0 \
  && ./autogen.sh \
  && ./configure --disable-wallet --disable-tests \
  && make && make install

RUN mkdir -p /root/.bitcoin
VOLUME /root/.bitcoin

RUN rm -rf ~/source

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
