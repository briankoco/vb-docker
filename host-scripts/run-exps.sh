#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: "$0" <total number of cores>"
    exit 2
fi

total_cores=$1
ip="172.20.0.11"

declare containers=(1)
sleep_time=10

for container in ${containers[@]}; do
    core=$(($total_cores / $container))

    # Clear caches
    sudo ./clear-caches.sh

    # Boot this
    ./start-cluster.sh $container $total_cores

    # Give it 10 seconds to come up
    for i in $(seq 1 $sleep_time); do
        echo "Waiting for $(($sleep_time - $i)) seconds until starting exps ..."
        sleep 1
    done

    # Run and archive results
    ssh -l cc -i ../ssh-keys/id_rsa.vb $ip \
        "pushd scripts && ./container-run.sh $container $total_cores && popd"

    # Get results
    #mkdir -p ../results
    #scp -i ../ssh-keys/id_rsa.vb cc@$ip:docker${container}-c${core}.tar.gz ../results/

    ./stop-cluster.sh $container
done
