#!/bin/bash
CUDA_VERSION=10.2
SYSTEM_VERSION=ubuntu-18
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

cd katago/cpp
rm -rf ./CMakeCache.txt
cmake . -DUSE_BACKEND=CUDA -DBUILD_DISTRIBUTED=1
make clean && make
cd -

cd katago
echo $katago_name
FULL_NAME=$katago_name-$SYSTEM_VERSION-cuda-$CUDA_VERSION
rm -rf ./$FULL_NAME && mkdir -p ./$FULL_NAME
cp ./cpp/katago ./$FULL_NAME/katago

cp /katabuild-env/run-katago.sh ./$FULL_NAME
chmod +x ./$FULL_NAME/run-katago.sh
chmod +x ./$FULL_NAME/katago


cp /lib/x86_64-linux-gnu/libz.so.1.2.11 ./$FULL_NAME
cp /usr/lib/x86_64-linux-gnu/libzip.so.4.0.0 ./$FULL_NAME
cp /usr/lib/x86_64-linux-gnu/libboost_filesystem.so.1.65.1  ./$FULL_NAME
cp /usr/lib/x86_64-linux-gnu/libboost_system.so.1.65.1 ./$FULL_NAME
cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.25 ./$FULL_NAME
cp /lib/x86_64-linux-gnu/libm-2.27.so ./$FULL_NAME
cd -

cd ./katago/$FULL_NAME
ln -s ./libz.so.1.2.11 ./libz.so.1
ln -s ./libzip.so.4.0.0 ./libzip.so.4
ln -s ./libstdc++.so.6.0.25 ./libstdc++.so.6
ln -s ./libm-2.27.so ./libm.so.6




