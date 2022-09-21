How to build example code for ARM.

1. Build processed on debian stretch linux; if you use other OS or linux distributive - install it as virtual machine or chroot.

1a. Setup build environment on Ubuntu 18.04

sudo apt install docker.io

2. Fetch SDK and example sources

git clone --recurse-submodules https://github.com/c3pio-man/pb-qt-3

2a. Switch into docker environment

cd pb-qt-3
./run-container.sh

This script prepare docker image, generate X authorization cookie and run shell in docker environment; current dir mapped to /BUILD in docker container.

Next steps must execute in docker.

2b. Download pre-built compiler and libs

./download-6.7.sh

2c. Configure build directory

Run configuration scripts

./env_set.sh
./SDK_6.3.0/SDK-B288/bin/update_path.sh 
 
3a. Cross-compile example code for ARM:

cd build/qml_test 
./makearm.sh

Build result must be found in output-arm directory. Copy test application output-arm/qml_test to applications/qml_test.app on device and run it as PB application

3b. Build example code for PC:

cd build/qml_test
./makepc.SH

Build result must be found in output-linux directory. 

Run output-linux/qml_test with pc-wrapper.sh:

../../pc-wrapper.sh output-linux/qml_test


4. Cross-compite browser-minimal for ARM (like qml_test):

cd build/browser-minimal
./nightbuild.sh

and for PC:
cd build/browser-minimal
./makepc.SH


5. To debug, pc-wrapper.sh can use with parameter -s:

../../pc-wrapper.sh -s output-linux/qml_test


