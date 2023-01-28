#!/bin/bash

# Require paths and such before proceeding
# if [[ -f common.sh ]]; then
#   source common.sh
# else
#   printf '%s\n' 'Could not find common.sh' >&2
#   exit 1
# fi

glibc_version=2.35
glibc_src="${SOURCES}/glibc-${glibc_version}.tar.xz"
glibc_work="${WORK}/glibc-${glibc_version}"
glibc_build="${glibc_work}/build"

function pre_build () {
	if [[ -d "${glibc_work}" ]]; then
		backup_if_present "${glibc_work}"
	fi
	if [[ -f "${glibc_src}" ]]; then
		info_msg "Unpacking source file at ${glibc_src}"
		tar -xf "${glibc_src}" -C "$(dirname "${glibc_work}")"
	else
		err_msg "Could not find source file at ${glibc_src}"
		exit 1
	fi
  if [[ -d "${glibc_work}" ]]; then
    cd "${glibc_work}" \
      || { err_msg "Could not change directory to ${glibc_work}"; exit 1; }
    mkdir -v "${glibc_build}"
    cd "${glibc_build}" \
      || { err_msg "Could not change directory to ${glibc_build}"; exit 1; }
    info_msg "Changed PWD to $(pwd -P)"
    return
  else
    err_msg "Could not create ${glibc_work}"
    exit 1
  fi
}

function config_build () {
  if [[ "$(pwd)" != "${glibc_build}" ]]; then
    err_msg "Unable to create glibc build directory at ${glibc_build}"
    exit 1
  fi

  local glibc_patch_1
  glibc_patch_1="${SOURCES}/glibc-2.35-fhs-1.patch"
  if [[ -f "${glibc_patch_1}" ]]; then
    info_msg "Patching sources."
    cd ..
    patch -Np1 -i "${glibc_patch_1}"
    cd build
  else
    # Drop a warning but continue building anyway
    warn_msg "No patch file found at ${glibc_patch_1}"
  fi

  # This is the first package we are building that will actually become resident
  # on the root filesystem intended for the target
  echo "rootsbindir=${ROOTFS}/usr/sbin" > configparms

  "${glibc_work}/configure" \
    --prefix="${ROOTFS}/usr" \
    --target="${TARGET}" \
    --host="${TARGET}" \
    --build="${BUILD}" \
    --enable-kernel=3.2 \
    --with-headers="${SYSROOT}/usr/${TARGET}/include" \
    libc_cv_slibdir="${ROOTFS}/usr/lib" > configure_"$(timestamp).log" 2>&1

  local build_timestamp_log
  build_timestamp_log="build_$(timestamp).log"
  make -j1 > "${build_timestamp_log}" 2>&1
}

function post_build () {
  local install_timestamp_log
  install_timestamp_log="install_$(timestamp).log"
  make DESTDIR="${TOOLCHAIN}" install > "${install_timestamp_log}" 2>&1
}

pre_build
config_build
post_build

