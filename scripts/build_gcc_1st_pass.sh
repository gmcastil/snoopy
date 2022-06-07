#!/bin/bash

# Require paths and such before proceeding
if [[ -f common.sh ]]; then
  source common.sh
else
  printf '%s\n' 'Could not find common.sh' >&2
  exit 1
fi

# These need to be installed too
_mpfr_version=4.1.0
_gmp_version=6.2.1
_mpc_version=1.2.1

_gcc_version=11.2.0
_gcc_src="${SOURCES}/gcc-${_gcc_version}.tar.xz"
_gcc_work="${WORK}/gcc-${_gcc_version}"
_gcc_build="${_gcc_work}/build"

function pre_build () {
  if [[ -d "${_gcc_work}" ]]; then
    backup_if_present "${_gcc_work}"
  fi
  if [[ -f "${_gcc_src}" ]]; then
    info_msg "Unpacking source file at ${_gcc_src}"
    tar -xJf "${_gcc_src}" -C "$(dirname "${_gcc_work}")"
  else
    err_msg "Could not find source file at ${_gcc_src}"
    exit 1
  fi
  if [[ -d "${_gcc_work}" ]]; then
    # Need to unpack the MPFR, GMP, and MPC sources prior to building GCC
    local mpfr_src
    local gmp_src
    local mpc_src
    mpfr_src="${SOURCES}/mpfr-${_mpfr_version}.tar.xz"
    gmp_src="${SOURCES}/gmp-${_gmp_version}.tar.xz"
    mpc_src="${SOURCES}/mpc-${_mpc_version}.tar.gz"
    # Nothing to back up, since we just unpacked the GCC tarball and are
    # unzipping these into it's directory
    info_msg "Unpacking source file at ${mpfr_src}"
    tar -xf "${mpfr_src}" \
      -C "${_gcc_work}/mpfr" \
      || { err_msg "Could not unpack ${mpfr_src}"; exit 1; }
    info_msg "Unpacking source file at ${gmp_src}"
    tar -xf "${gmp_src}" -C "${_gcc_work}/gmp" \
      -C "${_gcc_work}/gmp" \
      || { err_msg "Could not unpack ${gmp_src}"; exit 1; }
    info_msg "Unpacking source file at ${mpc_src}"
    tar -xf "${mpc_src}" -C "${_gcc_work}/mpc" \
      -C "${_gcc_work}/mpc" \
      || { err_msg "Could not unpack ${mpc_src}"; exit 1; }

    # Now relocate to the build directory
    cd "${_gcc_work}" \
      || { err_msg "Could not change directory to ${_gcc_work}"; exit 1; }
    mkdir -v "${_gcc_build}"
    cd "${_gcc_build}" \
      || { err_msg "Could not change directory to ${_gcc_build}"; exit 1; }
    info_msg "Changed PWD to $(pwd -P)"
    return
  else
    err_msg "Could not create ${_gcc_work}"
    exit 1
  fi
}

function config_build () {
  # Final check to make sure that we are in the appropriate location before
  # firing off configure or make
  if [[ "$(pwd)" != "${_gcc_build}" ]]; then
    err_msg "Unable to create GCC build directory at ${_gcc_build}"
    exit 1
  fi

  "${_gcc_work}/configure" \
    --target="${TARGET}" \
    --prefix="${TOOLCHAIN}" \
    --with-glibc-version=2.35 \
    --with-sysroot="${SYSROOT}" \
    --with-newlib \
    --without-headers \
    --enable-initfini-array \
    --disable-nls \
    --disable-shared \
    --disable-multilib \
    --disable-decimal-float \
    --disable-threads \
    --disable-libatomic \
    --disable-libgomp \
    --disable-libquadmath \
    --disable-libssp \
    --disable-libvtv \
    --disable-libstdcxx \
    --enable-languages=c,c++
  
}

function post_build () {
  local install_timestamp_log
  install_timestamp_log="install_$(timestamp).log"
  make install > "${install_timestamp_log}" 2>&1
  # Don't need documentation for this
  rm -rf "${TOOLCHAIN}/share"
}

pre_build
config_build
post_build

