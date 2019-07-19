FROM alpine AS base-proto

RUN apk add --no-cache git autoconf automake libtool make file g++
WORKDIR /sources
RUN git clone https://github.com/protocolbuffers/protobuf.git \
    && cd protobuf \
    && git submodule update --init --recursive \
    && ./autogen.sh \
    && ./configure --prefix=/binary-proto \
    && mkdir /binary \
    && make -j$(nproc) \
    && make check -j$(nproc) \
    && make install -j$(nproc)

FROM alpine AS base-arcus

COPY --from=base-proto /binary-proto /binary-proto

RUN apk add --no-cache git cmake autoconf automake libtool make file g++ python3 python3-dev py3-setuptools py-sip-dev py-sip
#WORKDIR /sources
#RUN hg clone https://www.riverbankcomputing.com/hg/sip \
#    && cd sip \
#    && python3 setup.py install
WORKDIR /sources
RUN git clone https://github.com/Ultimaker/libArcus.git \
    && cd libArcus \
    && mkdir build \
    && cd build \
    && cmake .. \
        -D Protobuf_USE_STATIC_LIBS=ON \
        -D Protobuf_INCLUDE_DIR=/binary-proto/include \
        -D Protobuf_LIBRARIES=/binary-proto/lib/libprotobuf.so \
        #-D SIP_EXECUTABLE=/usr/bin/sip5 \
        #-D SIP_INCLUDE_DIRS=/sources/sip \
        -D BUILD_EXAMPLES=OFF \
        -D CMAKE_INSTALL_PREFIX=/binary-arcus \
    && make \
    && make install 
FROM alpine AS base-cura

COPY --from=base-arcus /binary-arcus /binary-arcus
COPY --from=base-proto /binary-proto /binary-proto

RUN apk add --no-cache build-base cmake git
RUN git clone https://github.com/Ultimaker/CuraEngine.git \
    && cd CuraEngine \
    && mkdir build \
    && cd build \
    && cmake .. \ 
        -D Protobuf_INCLUDE_DIR=/binary-proto/include \
        -D Protobuf_LIBRARIES=/binary-proto/lib/libprotobuf.so \
        -D Arcus_DIR=/binary-arcus \
        -D CMAKE_PREFIX_PATH=/binary-arcus \
    && make
