#!/bin/bash
NUM=$1
: ${NUM:=1}
RATE=$2
: ${RATE:=10}
TIMEOUT=$3
: ${TIMEOUT:=5}
httperf --server=moocchat-load.herokuapp.com --method=POST --uri=/tasks/Learner+1/1/1 --num-conns=$NUM --rate=$RATE --timeout=$TIMEOUT
