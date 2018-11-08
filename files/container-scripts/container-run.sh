#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: "$0" <container count> <total core count>"
    exit 2
fi

container=$1
total_cores=$2
core=$(($total_cores / $container))

if [ $(($total_cores % $container)) -ne 0 ]; then
    echo "Cannot run experiment: container count not a factor of total cores"
    exit 2
fi

# Run
./run-os.py ${total_cores}
