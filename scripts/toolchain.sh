#!/bin/bash

# Returns a consistently formatted timestamp
function timestamp () {
  local retval
  retval="$(date +%H%M%S-%d%m%Y)"
  printf '%s' "${retval}"
}

function info_msg () {
  printf "INFO: %s\n" "$*" >&2
}

function warn_msg () {
  printf "WARNING: %s\n" "$*" >&2
}

function err_msg () {
  printf "ERROR: %s\n" "$*" >&2
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

# Binutils
function build_binutils () {
  local binutils_dir
  binutils_dir="${WORKING}/binutils-${BINUTILS_VER}"
  backup_if_present "${binutils_dir}"
}

# Kernel headers

# GCC pass 1

# C library

# GCC pass 2

if [[ -x ./common.sh ]]; then
 source ./common.sh 
else
  err_msg "File not found or not executable by current user"
  exit 1
fi

build_binutils
