#!/bin/bash

SYSTEM_VERSION=ubuntu-20
#KATAGO_DIR=./katago
#RUN_SCRIPT_DIR=/katabuild-env
KATAGO_DIR=./KataGo
RUN_SCRIPT_DIR=~/compile
katago_name=$1

if [ "$katago_name" == "" ]
then
    echo "You did not set the katago name"
    exit -1
fi

g++ --version
cmake --version 

cd $KATAGO_DIR/cpp
rm -rf ./CMakeCache.txt
cmake . -DUSE_BACKEND=OPENCL -DBUILD_DISTRIBUTED=0
make clean && make
cd -

cd $KATAGO_DIR
echo $katago_name
FULL_NAME=$katago_name-$SYSTEM_VERSION-opencl
rm -rf ./$FULL_NAME && mkdir -p ./$FULL_NAME
cp ./cpp/katago ./$FULL_NAME/katago

cp $RUN_SCRIPT_DIR/run-katago.sh ./$FULL_NAME
chmod +x ./$FULL_NAME/run-katago.sh
chmod +x ./$FULL_NAME/katago


cp /lib/x86_64-linux-gnu/libz.so.1.2.11 ./$FULL_NAME
cp /usr/lib/x86_64-linux-gnu/libzip.so.5.0 ./$FULL_NAME
cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.28 ./$FULL_NAME
cp /lib/x86_64-linux-gnu/libm-2.31.so ./$FULL_NAME
cp /lib/x86_64-linux-gnu/libbz2.so.1.0.4 ./$FULL_NAME
cp /lib/x86_64-linux-gnu/libcrypto.so.1.1 ./$FULL_NAME

cd -

cd ./$KATAGO_DIR/$FULL_NAME
ln -s ./libz.so.1.2.11 ./libz.so.1
ln -s ./libzip.so.5.0 ./libzip.so.5
ln -s ./libstdc++.so.6.0.28 ./libstdc++.so.6
ln -s ./libm-2.31.so ./libm.so.6
ln -s ./libbz2.so.1.0.4 ./libbz2.so.1.0




