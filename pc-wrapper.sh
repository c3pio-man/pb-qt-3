#!/bin/sh

. `dirname $0`/./env_set.sh

export LD_LIBRARY_PATH=${TOOLCHAIN_PATH}/local/lib/:${TOOLCHAIN_PATH}/local/qt5/lib/ 
export DIR_QT_LIBRARY_DATA=${TOOLCHAIN_PATH}/local/qt5
export QT_WEBENGINE_DISABLE_GPU=1

#cp -v ${TOOLCHAIN_PATH}/local/qt5/bin/qt.conf `dirname $1`
#cp -v ${TOOLCHAIN_PATH}/local/qt5/bin/qt.conf .
mkdir -p `dirname $1`/platforms
cp -v ${TOOLCHAIN_PATH}/local/qt5/lib/qtplugins/platforms/libqpocketbook2.so `dirname $1`/platforms
cp -rvf `dirname $0`/system .
cp -v ${TOOLCHAIN_PATH}/local/qt5/resources/icudtl.dat .
mkdir -p ~/.QtWebEngineProcess/
cp -v ${TOOLCHAIN_PATH}//local/qt5/resources/* ~/.QtWebEngineProcess/
#strace -f -e open `realpath $1`
`realpath $1`
