#!/bin/bash

# Require paths and such before proceeding
if [[ -f common.sh ]]; then
  source common.sh
else
  printf '%s\n' 'Could not find common.sh' >&2
  exit 1
fi

_binutils_version=2.38
_binutils_src="${SOURCES}/binutils-${_binutils_version}.tar.gz"
_binutils_work="${WORK}/binutils-${_binutils_version}"
_binutils_build="${_binutils_work}/build"

function pre_build () {
  if [[ -d "${_binutils_work}" ]]; then
    backup_if_present "${_binutils_work}"
  fi
  if [[ -f "${_binutils_src}" ]]; then
    info_msg "Unpacking source file at ${_binutils_src}"
    tar -xzf "${_binutils_src}" -C "$(dirname "${_binutils_work}")"
  else
    err_msg "Could not find source file at ${_binutils_src}"
    exit 1
  fi
  if [[ -d "${_binutils_work}" ]]; then
    cd "${_binutils_work}" \
      || { err_msg "Could not change directory to ${_binutils_work}"; exit 1; }
    mkdir -v "${_binutils_build}"
    cd "${_binutils_build}" \
      || { err_msg "Could not change directory to ${_binutils_build}"; exit 1; }
    info_msg "Changed PWD to $(pwd -P)"
    return
  else
    err_msg "Could not create ${_binutils_work}"
    exit 1
  fi
}

function config_build () {
  # Final check to make sure that we are in the appropriate location before
  # firing off configure or make
  if [[ "$(pwd)" != "${_binutils_build}" ]]; then
    err_msg "Unable to create binutils build directory at ${_binutils_build}"
    exit 1
  fi

  "${_binutils_work}/configure" \
    --enable-option-checking \
    --prefix="${TOOLCHAIN}" \
    --program-prefix="${TARGET}-" \
    --with-sysroot="${SYSROOT}" \
    --enable-deterministic-archives \
    --enable-threads \
    --disable-gold \
    --disable-plugins \
    --disable-gdb \
    --disable-multilib \
    --disable-werror \
    --with-system-zlib \
    --disable-sim \
    --target="${TARGET}" \
    --build="${BUILD}" \
    --host="${HOST}" > configure_"$(timestamp)".log 2>&1

  local build_timestamp_log
  build_timestamp_log="build_$(timestamp).log"
  make configure-host > "${build_timestamp_log}" 2>&1
  make tooldir="${TOOLCHAIN}" >> "${build_timestamp_log}" 2>&1
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

