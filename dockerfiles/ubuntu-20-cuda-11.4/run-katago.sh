#!/bin/bash
if [[ "$OSTYPE" == "darwin"* ]]
then
    RUN_KATAGO_SCRIPT=$(greadlink -f "$0")
else
    RUN_KATAGO_SCRIPT=$(readlink -f "$0")
fi
WORK_PATH=$(dirname "$RUN_KATAGO_SCRIPT")
export LD_LIBRARY_PATH=$WORK_PATH:$LD_LIBRARY_PATH
$WORK_PATH/katago $@