FROM alpine 

RUN apk add --no-cache git autoconf automake libtool make file g++ cmake python3 python3-dev py3-setuptools py-sip-dev py-sip
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8
WORKDIR /sources

RUN git clone https://github.com/protocolbuffers/protobuf.git \
    && git clone https://github.com/Ultimaker/libArcus.git \
    && git clone https://github.com/Ultimaker/CuraEngine.git 

RUN cd protobuf \
    && git submodule update --init --recursive \
    && ./autogen.sh \
    && ./configure  \
    && make -j$(nproc) \
    && make check -j$(nproc) \
    && make install -j$(nproc) \
    && cd ..

RUN cd libArcus \
    && mkdir build \
    && cd build \
    && cmake .. \
        -D BUILD_EXAMPLES=OFF \
    && make -j$(nproc) \
    && make install -j$(nproc)\
    && cd ../..

RUN cd CuraEngine \
    && mkdir build \
    && cd build \
    && cmake .. -D CMAKE_INSTALL_BINDIR=/binary \ 
    && make -j$(nproc)\
    && make 
