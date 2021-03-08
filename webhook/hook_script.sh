#!/bin/bash

wall "Test: webhook is working"

pipe=/opt/webhook/pipe/host_executor_queue

if [[ ! -p $pipe ]]; then
    echo "Reader not running"
    exit 1
fi

PAYLOAD=$1

if [[ "$PAYLOAD" ]]; then
    echo "$PAYLOAD" >$pipe
else
    echo "No data? $0 $1 $2" >$pipe
fi
