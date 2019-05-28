How to build example code for ARM.

1. Build processed on debian stretch linux; if you use other OS or linux distributive - install it as virtual machine or chroot.

1a. Setup build environment on Ubuntu 18.04

sudo apt install debootstrap schroot
sudo  debootstrap stretch debian-stretch

Detect yor login
id -u -n
and your primary group
id -g -n

Place to /etc/schroot/schroot.conf file section

[debian-stretch]
directory=/absolute/path/to/debian-stretch-directory
groups=_your_primary_group,root
description=debian-stretch
users=_your_login,root
type=directory

Uncomment in file /etc/schroot/default/fstab :
/dev/shm       /dev/shm        none    rw,bind         0       0

Install software into chrooted environment:
sudo schroot -c debian-stretch -d / -p
apt update
apt install g++ libfreetype6-dev libtag1-dev libjsoncpp-dev libgtk2.0-dev libcurl4-openssl-dev libjson-c-dev strace xterm patchelf mc git libjpeg-dev libjpeg62 strace

Create directory for buld
mkdir /BUILD
chown _your_login:_your_primary_group  /BUILD/

2. Get cross-compiller and example sources

Enter to chroot as ordinary user

schroot -c debian-stretch -d /BUILD -p

Fetch SDK and example sources

git clone --recurse-submodules -b 5.19 https://github.com/c3pio-man/pb-qt-3
(cd SDK_6.3.0/ && git checkout 5.19)
(cd build/qml_test/ && git checkout master)
(cd build/browser-minimal && git checkout master)

2a. Configure build directory

cd pb-qt-3
Run configuration scripts

./env_set.sh
./SDK_6.3.0/SDK-A13/bin/update_path.sh 
 
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


