FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install -y clinfo
RUN clinfo
RUN apt-get install -y git cmake g++ libboost-dev libboost-program-options-dev libboost-filesystem-dev opencl-headers ocl-icd-libopencl1 ocl-icd-opencl-dev zlib1g-dev

# Clone github repo
RUN git clone https://github.com/leela-zero/leela-zero
RUN cd leela-zero && git submodule update --init --recursive && cd -

# Use a stand alone build directory to keep source dir clean
RUN cd leela-zero && mkdir build && cd build && cmake .. && cmake --build .


