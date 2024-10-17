FROM ubuntu:latest

# avoid config interfaces
ARG DEBIAN_FRONTEND=noninteractive

# initial update and upgrade
RUN apt-get update && apt-get upgrade -y

#--------------------------------------------------
# build tools & base dependencies
#--------------------------------------------------
RUN apt-get update && apt-get install --install-recommends -y \
    clang-format \
    clang-tidy \
    git \
    gcc \
    g++ \
    gdb \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf \
    crossbuild-essential-arm64 \
    cmake \
    make \
    python3 \
    python3-pip \
    zlib1g-dev

RUN ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /
CMD ["bash"]
