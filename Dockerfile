# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang autoconf automake

## Add source code to the build stage.
ADD . /rp
WORKDIR /rp

RUN apt -y install ninja-build
RUN chmod +x /rp/src/build/build-release.sh
WORKDIR /rp/src/build/
RUN CC=clang CXX=clang++ CFLAGS=-fsanitize=address CXXFLAGS=-fsanitize=address ./build-release.sh

# Package Stage
FROM --platform=linux/amd64 ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /rp/src/build/rp-lin-x64 /rp-lin-x64
# 
