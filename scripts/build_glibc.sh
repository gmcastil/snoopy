#!/bin/bash

SNOOPY=${HOME}/git-repos/snoopy
TARGET=arm-snoopy-linux-gnueabihf

HOST=${SNOOPY}/host
SYSROOT=${SNOOPY}/sysroot
ROOTFS=${SNOOPY}/rootfs

PATH=${SNOOPY}/host/bin:${SNOOPY}/${TARGET}/bin:${PATH}

# case $(uname -m) in
#     i?86)   ln -sfv ld-linux.so.2 ${HOST}/lib/ld-lsb.so.3
#     ;;
#     x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 ${HOST}/lib64
#             ln -sfv ../lib/ld-linux-x86-64.so.2 ${HOST}/lib64/ld-lsb-x86-64.so.3
#     ;;
# esac

echo "rootsbindir=/usr/sbin" > configparms

mkdir -pv build
cd build

_logfile=configure_$(date +%H%M%S-%d%m%y).log

../configure                                   \
      --prefix=${SNOOPY}/rootfs                \
      --build=$(../scripts/config.guess)       \
      --host=${TARGET}                         \
      --enable-kernel=3.2                      \
      --with-headers=${SYSROOT}/usr/include    \
      libc_cv_slibdir=/usr/lib | tee ${_logfile}

make 2>&1 | tee -a ${_logfile}

make DESTDIR=${ROOTFS} install 2>&1 | tee -a ${_logfile}

