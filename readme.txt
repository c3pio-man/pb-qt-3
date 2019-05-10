How to build example code for ARM.

1. Get cross-compiller and example sources

git clone --recurse-submodules https://github.com/c3pio-man/pb-qt-3

2. Configure build directory

Run configuration scripts

./env_set.sh
./SDK_6.3.0/SDK-A13/bin/update_path.sh 
 
3. Cross-compile example code for ARM:

cd build/qml_test 
./makearm.sh

Build result must be found in output-arm directory. Copy test application output-arm/qml_test to applications/qml_test.app on device and run it as PB application

4. Build example code for PC:
You need install some libraries:
apt install g++ libfreetype6-dev libtag1-dev libjsoncpp-dev libgtk2.0-dev libcurl4-openssl-dev libjson-c-dev strace xterm patchelf mc

cd build/qml_test
./makepc.SH

Build result must be found in output-linux directory. 

Run output-linux/qml_test with pc-wrapper.sh:

../../pc-wrapper.sh output-linux/qml_test
