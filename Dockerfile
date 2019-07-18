FROM alpine AS base

RUN apk add --no-cache build-base autoconf cmake git python3-dev python3 py3-sip protobuf-dev

RUN git clone https://github.com/Ultimaker/CuraEngine.git
RUN cd CuraEngine && mkdir build && cd build && cmake .. && make
