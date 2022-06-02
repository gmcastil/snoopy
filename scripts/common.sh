#!/usr/bin/false

# This should not be a hard coded value
SNOOPY=${HOME}/git-repos/snoopy

# Probably the most important detail to get right
TARGET=arm-linux-snoopy-gnueabihf

WORK=${SNOOPY}/work
SOURCES=${SNOOPY}/sources

# Locations needed for the cross compiler
SYSROOT=${SNOOPY}/sysroot
HOST=${SNOOPY}/host

BINUTILS_VER=2.38
