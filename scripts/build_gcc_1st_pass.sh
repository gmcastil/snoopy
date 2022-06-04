#!/bin/bash

SNOOPY=${HOME}/git-repos/snoopy
TARGET=arm-snoopy-linux-gnueabihf

HOST=${SNOOPY}/host
SYSROOT=${SNOOPY}/sysroot

PATH=${SNOOPY}/host/bin:${SNOOPY}/${TARGET}/bin:${PATH}

../configure                  \
    --target=${TARGET}        \
    --prefix=${HOST}          \
    --with-glibc-version=2.35 \
    --with-sysroot=${SYSROOT} \
    --with-newlib             \
    --without-headers         \
    --enable-initfini-array   \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-decimal-float   \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --enable-languages=c,c++

_logfile=$(date +%H%M%S-%d%m%y)
make | tee ${_logfile}

make install | tee -a ${_logfile}

