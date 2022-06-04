Introduction
------------
I had hoped that I would be able to just sit down and crank out some shell
scripts to automate a lot of this, but in the end, it made more sense to just
document what I've been doing, what the outcome of each step in the sequence has
been, and how to actually do everything from scratch instead.

Binutils
--------
The binutils package contains, among other things, the assembler and linker
needed to build and generate binaries for the target platform.

First, we make a directory in the binutils source directory called `build`, and
then run `configure` from that location, with a bunch of options
```bash
mkdir -v build && cd build
../configure \
  --enable-option-checking \
  --with-sysroot=${SYSROOT} \
  --prefix=$HOST \
  --disable-nls \
  --disable-werror \
  --target=arm-snoopy-linux-gnueabihf \
  --build=$(../config.guess) \
  --host=$(../config.guess)
```
The `--enable-option-checking` option was one I hadn't seen before, so I tried
with and without it, and it interestingly noted that the `--with-sysroot` and
`--disable-nls` options were unknown.  I would speculate that they are simply
passed on so that the calls to `make` get them.
```bash
make all
make install
```
After this, the following changes can be seen in the directory tree
```bash
castillo@ubuntu-22:~/git-repos/snoopy$ tree -d -I work/host
.
├── arm-snoopy-linux-gnueabihf
│   ├── bin
│   │   ├── ar
│   │   ├── as
│   │   ├── ld
│   │   ├── ld.bfd
│   │   ├── nm
│   │   ├── objcopy
│   │   ├── objdump
│   │   ├── ranlib
│   │   ├── readelf
│   │   └── strip
│   └── lib
│       └── ldscripts
│           ├── armelfb_linux_eabi.x
│           ├── armelfb_linux_eabi.xbn
│           ├── armelfb_linux_eabi.xc
│           ├── armelfb_linux_eabi.xce
│           ├── armelfb_linux_eabi.xd
│           ├── armelfb_linux_eabi.xdc
│           ├── armelfb_linux_eabi.xdce
│           ├── armelfb_linux_eabi.xde
│           ├── armelfb_linux_eabi.xdw
│           ├── armelfb_linux_eabi.xdwe
│           ├── armelfb_linux_eabi.xe
│           ├── armelfb_linux_eabi.xn
│           ├── armelfb_linux_eabi.xr
│           ├── armelfb_linux_eabi.xs
│           ├── armelfb_linux_eabi.xsc
│           ├── armelfb_linux_eabi.xsce
│           ├── armelfb_linux_eabi.xse
│           ├── armelfb_linux_eabi.xsw
│           ├── armelfb_linux_eabi.xswe
│           ├── armelfb_linux_eabi.xu
│           ├── armelfb_linux_eabi.xw
│           ├── armelfb_linux_eabi.xwe
│           ├── armelf_linux_eabi.x
│           ├── armelf_linux_eabi.xbn
│           ├── armelf_linux_eabi.xc
│           ├── armelf_linux_eabi.xce
│           ├── armelf_linux_eabi.xd
│           ├── armelf_linux_eabi.xdc
│           ├── armelf_linux_eabi.xdce
│           ├── armelf_linux_eabi.xde
│           ├── armelf_linux_eabi.xdw
│           ├── armelf_linux_eabi.xdwe
│           ├── armelf_linux_eabi.xe
│           ├── armelf_linux_eabi.xn
│           ├── armelf_linux_eabi.xr
│           ├── armelf_linux_eabi.xs
│           ├── armelf_linux_eabi.xsc
│           ├── armelf_linux_eabi.xsce
│           ├── armelf_linux_eabi.xse
│           ├── armelf_linux_eabi.xsw
│           ├── armelf_linux_eabi.xswe
│           ├── armelf_linux_eabi.xu
│           ├── armelf_linux_eabi.xw
│           └── armelf_linux_eabi.xwe
├── bin
│   ├── arm-snoopy-linux-gnueabihf-addr2line
│   ├── arm-snoopy-linux-gnueabihf-ar
│   ├── arm-snoopy-linux-gnueabihf-as
│   ├── arm-snoopy-linux-gnueabihf-c++filt
│   ├── arm-snoopy-linux-gnueabihf-elfedit
│   ├── arm-snoopy-linux-gnueabihf-gprof
│   ├── arm-snoopy-linux-gnueabihf-ld
│   ├── arm-snoopy-linux-gnueabihf-ld.bfd
│   ├── arm-snoopy-linux-gnueabihf-nm
│   ├── arm-snoopy-linux-gnueabihf-objcopy
│   ├── arm-snoopy-linux-gnueabihf-objdump
│   ├── arm-snoopy-linux-gnueabihf-ranlib
│   ├── arm-snoopy-linux-gnueabihf-readelf
│   ├── arm-snoopy-linux-gnueabihf-size
│   ├── arm-snoopy-linux-gnueabihf-strings
│   └── arm-snoopy-linux-gnueabihf-strip
├── lib
│   └── bfd-plugins
│       └── libdep.so
└── share
    ├── info
    │   ├── as.info
    │   ├── bfd.info
    │   ├── binutils.info
    │   ├── ctf-spec.info
    │   ├── dir
    │   ├── gprof.info
    │   └── ld.info
    └── man
        └── man1
            ├── arm-snoopy-linux-gnueabihf-addr2line.1
            ├── arm-snoopy-linux-gnueabihf-ar.1
            ├── arm-snoopy-linux-gnueabihf-as.1
            ├── arm-snoopy-linux-gnueabihf-c++filt.1
            ├── arm-snoopy-linux-gnueabihf-dlltool.1
            ├── arm-snoopy-linux-gnueabihf-elfedit.1
            ├── arm-snoopy-linux-gnueabihf-gprof.1
            ├── arm-snoopy-linux-gnueabihf-ld.1
            ├── arm-snoopy-linux-gnueabihf-nm.1
            ├── arm-snoopy-linux-gnueabihf-objcopy.1
            ├── arm-snoopy-linux-gnueabihf-objdump.1
            ├── arm-snoopy-linux-gnueabihf-ranlib.1
            ├── arm-snoopy-linux-gnueabihf-readelf.1
            ├── arm-snoopy-linux-gnueabihf-size.1
            ├── arm-snoopy-linux-gnueabihf-strings.1
            ├── arm-snoopy-linux-gnueabihf-strip.1
            ├── arm-snoopy-linux-gnueabihf-windmc.1
            └── arm-snoopy-linux-gnueabihf-windres.1
```
The noteworthy results here are that the output proudcts of binutils have been
installed into $HOST in two places, the $HOST/bin and ${HOST}/${TARGET}/bin.
These are all x86-64 binaries dynamically linked against the C library in
/lib/x86_64-linux-gnu/libc.so.6


Kernel Headers
--------------
I'm assuming that at some point these are going to be needed for a root
filesystem of some sort, so we'll go ahead and install them now into that
directory.
```bash
make mrproper
make headers
find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include ${SNOOPY}/rootfs/usr
```
Now, at some point in the future, binaries will eventually be linked against
these.  I hope.

A Minimal GCC
-------------
The next step in the toolchain build is to compile a minimal copy of the GNU
C/C++ compilers, sufficient enough to build a copy of the GNU C library in the
next step.

```bash
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
```
Once this is completed, the first pass C/C++ compilers were installed to
${SNOOPY}/host/bin.  It isn't clear to me why binutils installed itself into two
locations, each with different names. As expected, a quick check of the contents
of host/bin/ show that everything is still linked against the C library on the
host system in `/lib64/x86_64-linux-gnu/libc.so.6`

GNU C Library Build
-------------------



