#!/bin/bash
if [[ "$OSTYPE" == "darwin"* ]]
then
    RUN_LEELA_SCRIPT=$(greadlink -f "$0")
else
    RUN_LEELA_SCRIPT=$(readlink -f "$0")
fi

LEELA_ARGS=$@
if [ "$1" == "gtp" ]
then
    MODEL_FILE=$3
    CONFIG_FILE=$5
    echo using model: $MODEL_FILE, config file: $CONFIG_FILE
    OTHER_ARGS=""
    while read line
    do
       name=$(echo $line | cut -d'=' -f1)
       value=$(echo $line | cut -d'=' -f2)
       bytlen=${#name}
       if [ $bytlen -eq 1 ]
       then
               OTHER_ARGS="$OTHER_ARGS -$name $value"
       else
               OTHER_ARGS="$OTHER_ARGS --$name $value"
       fi
    done < $CONFIG_FILE
    LEELA_ARGS="-g -w $MODEL_FILE $OTHER_ARGS"
fi
echo $LEELA_ARGS
WORK_PATH=$(dirname "$RUN_LEELA_SCRIPT")
export LD_LIBRARY_PATH=$WORK_PATH:$LD_LIBRARY_PATH
$WORK_PATH/leelaz $LEELA_ARGS