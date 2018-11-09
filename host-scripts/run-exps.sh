#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: "$0" <total number of cores>"
    exit 2
fi

total_cores=$1
ip="172.20.0.11"

declare containers=(4)
sleep_time=10

for container in ${containers[@]}; do
    core=$(($total_cores / $container))

    # Clear caches
    sudo ./clear-caches.sh

    # Boot this
    results_dir="$(pwd)/../results/${container}containers-${core}cores"
    mkdir -p $results_dir
    rm -f ${results_dir}/*
    ./start-cluster.sh $container $total_cores $results_dir

    # Give it 10 seconds to come up
    for i in $(seq 1 $sleep_time); do
        echo "Waiting for $(($sleep_time - $i)) seconds until starting exps ..."
        sleep 1
    done

    # Run experiments 
    ssh -l cc -i ../ssh-keys/id_rsa.vb $ip \
        "pushd scripts && ./container-run.sh $container $total_cores && popd"

    # scp the results out
    hosts=`awk '{print $1}' hostfile`
    for h in ${hosts[@]}; do
        echo "Retrieving results from $h"
        mkdir -p "$results_dir/$h"
        scp -i ../ssh-keys/id_rsa.vb -r cc@$h:results $results_dir/$h
    done

    ./stop-cluster.sh $container
done
