#!/bin/bash

# Set up some environment variables to make it easier to develop toolchain
# build scripts

BUILD=x86_64-pc-linux-gnu
HOST=x86_64-pc-linux-gnu
TARGET=arm-snoopy-linux-gnueabihf

# This should not be a hard coded value
SNOOPY="${HOME}"/git-repos/snoopy
# Locations to work out of
SOURCES="${SNOOPY}"/sources
WORK="${SNOOPY}"/work

# Locations to install tools and output products to
TOOLCHAIN="${SNOOPY}"/toolchain
ROOTFS="${SNOOPY}"/rootfs
SYSROOT="${SNOOPY}"/sysroot

export SNOOPY
export TARGET
export BUILD
export HOST
export SOURCES
export WORK
export TOOLCHAIN
export ROOTFS
export SYSROOT

if [[ "${BUILD_DEBUG}" == "yes" ]]; then
  printf 'BUILD = %s\n' "${BUILD}"
  printf 'HOST = %s\n' "${HOST}"
  printf 'TARGET = %s\n' "${TARGET}"

  printf 'SNOOPY = %s\n' "${SNOOPY}"
  printf 'SOURCES = %s\n' "${SOURCES}"
  printf 'WORK = %s\n' "${WORK}"
  printf 'TOOLCHAIN = %s\n' "${TOOLCHAIN}"
  printf 'ROOTFS = %s\n' "${ROOTFS}"
  printf 'SYSROOT = %s\n' "${SYSROOT}"
fi

# Define some helper functions that will get used and reused by some of
# the toolchain build scripts
function info_msg () {
  printf "INFO: %s\n" "$*" >&2 
}

function warn_msg () {
  printf "WARNING: %s\n" "$*" >&2 
}

function err_msg () {
  printf "ERROR: %s\n" "$*" >&2 
}

# Returns a consistently formatted timestamp
function timestamp () {
  local retval
  retval="$(date +%H%M%S-%d%m%Y)"
  printf '%s' "${retval}"
}

# Move and backup an existing directory if its present
function backup_if_present () {
  if [[ -d "${1}" ]]; then
    info_msg "${1} was found and will be renamed."
    local backup_dir
    backup_dir="${1}_$(timestamp)"
    mv -v "${1}" "${backup_dir}"
    # Now check again and if not, there was a problem of some sort
    if [[ -d "${1}" ]]; then
      err_msg "$1 was found and could not be backed up. Check permissions."
      exit 1
    else
      return 0
    fi  
  fi  
}

