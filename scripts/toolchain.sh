#!/bin/bash

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

# Backup an existing directory if it already exists
function backup_if_present () {
  if [[ -d "${1}" ]]; then
    info_msg "${1} was found and will be renamed."
    local backup_dir
    backup_dir="${1}.$(timestamp)"
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

# Make directories if they don't already exist and verify access
function mkdir_if_needed () {
  backup_if_present "${1}"
  local dir=$(basename "${1}")
  if [[ ! -d "${1}" ]]; then
    info_msg "No ${dir} directory found and one will be created"
    mkdir -v "${1}"
    if [[ ! -d "${1}" ]]; then
      err_msg "Could not create directory at ${1}"
      exit 1
    fi
  else
    err_msg "An existing ${dir} directory was found and could not be moved"
    exit 1
  fi
}

# Binutils
function build_binutils () {
  # Backup old source tree
  # Extract source code
  # Make build directory
  # Change to build directory
  # configure
  # make
  # make install
  local binutils_dir
  binutils_dir="${WORK}/binutils-${BINUTILS_VER}"
  backup_if_present "${binutils_dir}"

}

# Kernel headers

# GCC pass 1

# C library

# GCC pass 2

if [[ -x ./common.sh ]]; then
 source ./common.sh 
else
  err_msg "One or more required files not found or not executable by current user"
  exit 1
fi

# Make sure that a working directory exists and that it is writable by the
# current user

# Make host, target, sysroot directories
mkdir_if_needed "${SYSROOT}"
mkdir_if_needed "${HOST}"

build_binutils
