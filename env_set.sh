#!/bin/bash
if [ $(basename "$0") = "env_set.sh" ]; then sed -e "s+^BUILDROOT=..*+BUILDROOT="$(realpath "$(dirname "$0")")"+" -i $0; fi
BUILDROOT=/usr/local/TEST_BUILD/bp-qt-3
#SDK_SELECTED=SDK_6.3.0/SDK-A13 # A13-based devices (626, 627, 641, 840)
SDK_SELECTED=SDK_6.3.0/SDK-B288 # B288-based (632, 740)
#SDK_SELECTED=SDK_6.3.0/SDK-iMX6 # 631
CMAKE_CXX_COMPILER=${BUILDROOT}/${SDK_SELECTED}/usr/bin/arm-obreey-linux-gnueabi-clang++
CMAKE_C_COMPILER=${BUILDROOT}/${SDK_SELECTED}/usr/bin/arm-obreey-linux-gnueabi-clang
CMAKE_TOOLCHAIN_FILE=${BUILDROOT}/${SDK_SELECTED}/share/cmake/arm_conf.cmake
PB_DESTFS=${BUILDROOT}/ebrmain_fs
PB_QT_XPLATFORM=linux-arm-gnueabi-630-clang++
PB_SDK_CFG=${BUILDROOT}/${SDK_SELECTED}/config.cmake
PB_STRIP=${BUILDROOT}/${SDK_SELECTED}/usr/bin/arm-obreey-linux-gnueabi-strip
PB_TOOLCHAIN_PATH=${BUILDROOT}/${SDK_SELECTED}
PB_TOOLCHAIN_PREFIX=arm-obreey-linux-gnueabi
TOOLCHAIN_PATH=${BUILDROOT}/${SDK_SELECTED}/usr
TOOLCHAIN_PREFIX=arm-obreey-linux-gnueabi

export BUILDROOT
export CMAKE_CXX_COMPILER
export CMAKE_C_COMPILER
export CMAKE_TOOLCHAIN_FILE
export PB_DESTFS
export PB_QT_XPLATFORM
export PB_SDK_CFG
export PB_STRIP
export PB_TOOLCHAIN_PATH
export PB_TOOLCHAIN_PREFIX
export TOOLCHAIN_PATH
export TOOLCHAIN_PREFIX

