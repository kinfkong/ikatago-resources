#!/bin/bash
CUDA_VERSION=11.4
SYSTEM_VERSION=ubuntu-20
export PATH=/usr/local/cuda-$CUDA_VERSION/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-$CUDA_VERSION/lib64:$LD_LIBRARY_PATH

katago_name=$1

if [ "$katago_name" == "" ]
then
    echo "You did not set the katago name"
    exit -1
fi

g++ --version
cmake --version 

build_katago () {
    BACKEND_TYPE=$1
    cd KataGo/cpp
    rm -rf ./CMakeCache.txt
    cmake . -DUSE_BACKEND=$BACKEND_TYPE -DBUILD_DISTRIBUTED=1
    make clean && make -j
    cd -

    #echo $katago_name
    FULL_NAME=$katago_name-$SYSTEM_VERSION-cuda-$CUDA_VERSION-$BACKEND_TYPE
    echo $FULL_NAME

    cd KataGo
    rm -rf ./$FULL_NAME && mkdir -p ./$FULL_NAME
    cp ./cpp/katago ./$FULL_NAME/katago
    cp /katabuild-env/run-katago.sh ./$FULL_NAME
    chmod +x ./$FULL_NAME/run-katago.sh
    chmod +x ./$FULL_NAME/katago
    
    cp /usr/lib/x86_64-linux-gnu/libzip.so.5.0.0 ./$FULL_NAME
    cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.28 ./$FULL_NAME
    cp /lib/x86_64-linux-gnu/libm-2.31.so ./$FULL_NAME

    cd -

    cd ./KataGo/$FULL_NAME
    ln -s ./libzip.so.5.0.0 ./libzip.so.5
    ln -s ./libstdc++.so.6.0.28 ./libstdc++.so.6
    ln -s ./libm-2.31.so ./libm.so.6
    cd - 
}

build_katago CUDA
build_katago OPENCL
build_katago TENSORRT



