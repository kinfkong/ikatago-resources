FROM ubuntu:16.04 as original
ENV CUDA_VERSION=9.2
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

# install cuda for ubuntu1604-cuda9.2
COPY ./cuda-repo-ubuntu1604_9.2.148-1_amd64.deb ./cuda-repo-ubuntu1604_9.2.148-1_amd64.deb
RUN dpkg -i cuda-repo-ubuntu1604_9.2.148-1_amd64.deb
RUN apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install cuda


#include cudnn
RUN wget --no-check-certificate https://ikatago-resources.oss-cn-beijing.aliyuncs.com/cudnn-${CUDA_VERSION}-linux-x64-v7.6.5.32.tgz
RUN tar -xzvf ./cudnn-${CUDA_VERSION}-linux-x64-v7.6.5.32.tgz
RUN cp cuda/include/cudnn.h /usr/local/cuda-${CUDA_VERSION}/include
RUN cp cuda/lib64/libcudnn* /usr/local/cuda-${CUDA_VERSION}/lib64

RUN apt-get install -y libzip-dev zlib1g-dev libboost-filesystem-dev

FROM ubuntu:16.04 

COPY --from=original /usr /usr-new
RUN rm -rf /usr && mv /usr-new /usr
COPY --from=original /etc/alternatives /etc/alternatives
WORKDIR /katabuild-env
COPY ./build.sh ./build
COPY ./run-katago.sh ./run-katago.sh
RUN chmod +x ./build
CMD ["/katabuild-env/build"]
