#!/bin/bash

# Require paths and such before proceeding
if [[ -f common.sh ]]; then
  source common.sh
else
  printf '%s\n' 'Could not find common.sh' >&2
  exit 1
fi

# case $(uname -m) in
#     i?86)   ln -sfv ld-linux.so.2 ${HOST}/lib/ld-lsb.so.3
#     ;;
#     x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 ${HOST}/lib64
#             ln -sfv ../lib/ld-linux-x86-64.so.2 ${HOST}/lib64/ld-lsb-x86-64.so.3
#     ;;
# esac

echo "rootsbindir=/usr/sbin" > configparms

function pre_build () {
	if [[ -d "${_glibc_work}" ]]; then
		backup_if_present "${_glibc_work}"
	fi
	if [[ -f "${_glibc_src}" ]]; then
		info_msg "Unpacking source file at ${_glibc_src}"
		tar -xf "${_glibc_src}" -C "$(dirname "${_glibc_work}")"
	else
		err_msg "Could not find source file at ${_glibc_src}"
		exit 1
	fi
}
