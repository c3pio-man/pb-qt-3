#!/bin/bash

rootdir=$(realpath $(dirname $0))
. ${rootdir}/env_set.sh

export LD_LIBRARY_PATH=${TOOLCHAIN_PATH}/local/lib/:${TOOLCHAIN_PATH}/local/qt5/lib/ 
export DIR_QT_LIBRARY_DATA=${TOOLCHAIN_PATH}/local/qt5
export QT_WEBENGINE_DISABLE_GPU=1
export QTWEBENGINE_CHROMIUM_FLAGS="--single-process"

strace=
if [ "$1" = -s ]; then
strace="strace -ff -ostrace.log"
shift
fi

exe=`realpath $1`
shift


cp -v ${TOOLCHAIN_PATH}/local/qt5/bin/qt.conf `dirname $exe`
mkdir -p `dirname $exe`/platforms
cp -v ${TOOLCHAIN_PATH}/local/qt5/lib/qtplugins/platforms/libqpocketbook2.so `dirname $exe`/platforms
if ! [ -d system ]; then
cp -rvf ${rootdir}/system .
fi
mkdir -p ~/.QtWebEngineProcess/
cp -v ${TOOLCHAIN_PATH}//local/qt5/resources/* ~/.QtWebEngineProcess/
#if [ -z "$strace" ]; then
#$exe $*
#else
$strace $exe $*
#fi
