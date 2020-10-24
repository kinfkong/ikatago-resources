FROM ubuntu:18.04 as original
ENV CUDA_VERSION=10.0
# upgrade gcc
RUN apt-get update && apt-get install -y git cmake wget curl software-properties-common 
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt update
RUN apt install g++-7 -y
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 \
                         --slave /usr/bin/g++ g++ /usr/bin/g++-7 
RUN update-alternatives --config gcc

RUN wget https://www.openssl.org/source/openssl-1.1.1c.tar.gz
RUN tar xvf openssl-1.1.1c.tar.gz && cd openssl-1.1.1c && ./config -Wl,--enable-new-dtags,-rpath,'$(LIBRPATH)' && make && make install && cd -

# upgrade cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.18.1/cmake-3.18.1-Linux-x86_64.sh
RUN chmod +x cmake-3.18.1-Linux-x86_64.sh 
RUN yes | ./cmake-3.18.1-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir

# install cuda for ubuntu1804-cuda10.0
RUN wget https://ikatago-resources.oss-cn-beijing.aliyuncs.com/cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64.deb
RUN dpkg -i cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64.deb
RUN apt-key add /var/cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1/7fa2af80.pub
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install cuda


#include cudnn
RUN wget --no-check-certificate https://ikatago-resources.oss-cn-beijing.aliyuncs.com/cudnn-${CUDA_VERSION}-linux-x64-v7.6.5.32.tgz
RUN tar -xzvf ./cudnn-${CUDA_VERSION}-linux-x64-v7.6.5.32.tgz

RUN cp -P cuda/include/*.h /usr/local/cuda-${CUDA_VERSION}/include
RUN cp -P cuda/lib64/libcudnn* /usr/local/cuda-${CUDA_VERSION}/lib64

RUN apt-get install -y libzip-dev zlib1g-dev libboost-filesystem-dev

WORKDIR /katabuild-env
COPY ./build.sh ./build
COPY ./run-katago.sh ./run-katago.sh
RUN chmod +x ./build
CMD ["/katabuild-env/build"]