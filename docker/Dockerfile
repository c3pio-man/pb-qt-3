FROM debian:9.3
WORKDIR /
ARG DEBIAN_FRONTEND=noninteractive

ARG uid
ARG docker_gid 
RUN useradd jenkins -m -l -u $uid -s /bin/bash && mkdir -p /home/jenkins/.ssh/ && chmod 700 /home/jenkins/.ssh/ && addgroup --gid $docker_gid docker && adduser jenkins docker

RUN dpkg --add-architecture i386 

RUN apt-get update && apt-get install -y wget g++ gcc make libssl1.0-dev libstdc++-6-dev:i386 bc bzip2 git libncurses-dev mercurial time unzip vim curl zlib1g-dev libpng-dev libjpeg-dev libtiff-dev libcurl4-openssl-dev libgtk2.0-dev libsqlite3-dev libopencv-dev libjsoncpp-dev libjson-c-dev libxml2-dev libboost-dev libtag1-dev libboost-program-options-dev bison gperf clang-4.0 patchelf libc6-dev-i386 chrpath g++-6-multilib g++-multilib p7zip-full imagemagick cpio libgif-dev libdw-dev libicu-dev

RUN apt-get update && apt-get install -y xterm strace cmake

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD bas
