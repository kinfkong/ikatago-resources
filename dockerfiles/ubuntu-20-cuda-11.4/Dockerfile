FROM ubuntu:20.04 as original
ENV CUDA_VERSION=11.4
# upgrade gcc
RUN DEBIAN_FRONTEND=noninteractive apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git cmake wget curl software-properties-common 
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt update
RUN apt install g++-7 -y
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 \
                         --slave /usr/bin/g++ g++ /usr/bin/g++-7 
RUN update-alternatives --config gcc

RUN wget https://www.openssl.org/source/openssl-1.1.1c.tar.gz
RUN tar xvf openssl-1.1.1c.tar.gz && cd openssl-1.1.1c && ./config -Wl,--enable-new-dtags,-rpath,'$(LIBRPATH)' && make && make install && cd -

# upgrade cmake
ENV CMAKE_VERSION=3.20.6
RUN wget https://ikatago-resources.oss-cn-beijing.aliyuncs.com/cmake-${CMAKE_VERSION}-linux-x86_64.sh
RUN chmod +x cmake-${CMAKE_VERSION}-linux-x86_64.sh 
RUN yes | ./cmake-${CMAKE_VERSION}-linux-x86_64.sh --prefix=/usr/local --exclude-subdir

# install cuda for ubuntu2004-cuda11.4
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
RUN mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
RUN wget https://ikatago-resources.oss-cn-beijing.aliyuncs.com/cuda-repo-ubuntu2004-11-4-local_11.4.2-470.57.02-1_amd64.deb
RUN dpkg -i cuda-repo-ubuntu2004-11-4-local_11.4.2-470.57.02-1_amd64.deb
RUN apt-key add /var/cuda-repo-ubuntu2004-11-4-local/7fa2af80.pub
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install cuda

#include cudnn
RUN wget --no-check-certificate https://ikatago-resources.oss-cn-beijing.aliyuncs.com/cudnn-${CUDA_VERSION}-linux-x64-v8.2.4.15.tgz
RUN tar -xzvf ./cudnn-${CUDA_VERSION}-linux-x64-v8.2.4.15.tgz

RUN cp cuda/include/*.h /usr/local/cuda-${CUDA_VERSION}/include
RUN cp -P cuda/lib64/libcudnn* /usr/local/cuda-${CUDA_VERSION}/lib64

RUN apt-get install -y libzip-dev zlib1g-dev libboost-filesystem-dev

#install opencl
RUN apt-get install -y ocl-icd-opencl-dev clinfo

#install tensorRT
RUN wget --no-check-certificate https://ikatago-resources.oss-cn-beijing.aliyuncs.com/nv-tensorrt-repo-ubuntu2004-cuda11.4-trt8.2.0.6-ea-20210922_1-1_amd64.deb
RUN dpkg -i nv-tensorrt-repo-ubuntu2004-cuda11.4-trt8.2.0.6-ea-20210922_1-1_amd64.deb
RUN apt-key add /var/nv-tensorrt-repo-ubuntu2004-cuda11.4-trt8.2.0.6-ea-20210922/7fa2af80.pub
RUN apt-get update
RUN apt-get install -y tensorrt

WORKDIR /katabuild-env
COPY ./build.sh ./build
COPY ./run-katago.sh ./run-katago.sh
RUN chmod +x ./build
CMD ["/katabuild-env/build"]
