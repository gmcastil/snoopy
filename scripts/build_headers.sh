#!/bin/bash

# Require paths and such before proceeding
if [[ -f common.sh ]]; then
  source common.sh
else
  printf '%s\n' 'Could not find common.sh' >&2
  exit 1
fi

_linux_version=5.18
_linux_src="${SOURCES}/linux-${_linux_version}.tar.xz"
_linux_work="${WORK}/linux-${_linux_version}"
_linux_build="${_linux_work}"

function pre_build () {
  if [[ -d "${_linux_work}" ]]; then
    backup_if_present "${_linux_work}"
  fi  
  if [[ -f "${_linux_src}" ]]; then
    info_msg "Unpacking source file at ${_linux_src}"
    tar -xJf "${_linux_src}" -C "$(dirname "${_linux_work}")"
  else
    err_msg "Could not find source file at ${_linux_src}"
    exit 1
  fi 
  cd "${_linux_build}" \
    || { err_msg "Could not change directory to ${_linux_build}"; exit 1; }
  return
}

function config_build () {
  if [[ "$(pwd)" != "${_linux_build}" ]]; then
    err_msg "Unable to enter Linux headers build directory at ${_linux_build}"
    exit 1
  fi

  # The Linux kernel build doesn't look for the normal GNU target triplet,
  # so we specify the ARCH manually
  make ARCH="${ARCH_TARGET}" mrproper
  make ARCH="${ARCH_TARGET}" headers
  make \
    ARCH="${ARCH_TARGET}" \
    INSTALL_HDR_PATH="${SYSROOT}/usr/${TARGET}" \
    headers_install
}

function post_build () {
  local linux_hdr_dir
  linux_hdr_dir="${_linux_build}/usr/include"
  if [[ -d "${linux_hdr_dir}" ]]; then
    # Remove all of the .cmd and other hidden files
    find "${linux_hdr_dir}" -name '.*' -delete
    rm "${linux_hdr_dir}"/Makefile
    mkdir -pv "${SYSROOT}/usr"
    cp -rv "${linux_hdr_dir}" "${SYSROOT}/usr"
  else
    err_msg "Could not find Linux header directory at ${linux_hdr_dir}"
    exit 1
  fi
}

pre_build
config_build
# post_build

