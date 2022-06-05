#!/bin/bash

# Set up some environment variables to make it easier to develop toolchain
# build scripts

BUILD=x86_64-pc-linux-gnu
HOST=x86_64-pc-linux-gnu
TARGET=arm-linux-snoopy-gnueabihf

# This should not be a hard coded value
SNOOPY=${HOME}/git-repos/snoopy
# Locations to work out of
SOURCES=${SNOOPY}/sources
WORK=${SNOOPY}/work

# Locations to install tools and output products to
TOOLCHAIN=${SNOOPY}/toolchain
ROOTFS=${SNOOPY}/rootfs
SYSROOT=${SNOOPY}/sysroot

printf 'BUILD = %s\n' ${BUILD}
printf 'HOST = %s\n' ${HOST}
printf 'TARGET = %s\n' ${TARGET}

printf 'SNOOPY = %s\n' ${SNOOPY}
printf 'SOURCES = %s\n' ${SOURCES}
printf 'WORK = %s\n' ${WORK}
printf 'TOOLCHAIN = %s\n' ${TOOLCHAIN}
printf 'ROOTFS = %s\n' ${ROOTFS}
printf 'SYSROOT = %s\n' ${SYSROOT}

export SNOOPY
export TARGET
export BUILD
export HOST
export SOURCES
export WORK
export TOOLCHAIN
export ROOTFS
export SYSROOT

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

