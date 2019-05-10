#!/bin/sh

. ./env_set.sh

export LD_LIBRARY_PATH=${TOOLCHAIN_PATH}/local/lib/:${TOOLCHAIN_PATH}/local/qt5/lib/ 

cp -v ${TOOLCHAIN_PATH}/local/qt5/bin/qt.conf `dirname $1`
mkdir -p `dirname $1`/platforms
cp -v ${TOOLCHAIN_PATH}/local/qt5/lib/qtplugins/platforms/libqpocketbook2.so `dirname $1`/platforms
cp -rvf `dirname $0`/system `dirname $1`

$1
