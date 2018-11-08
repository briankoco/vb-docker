#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: "$0" <nr containers>"
    exit 2
fi

nr_containers=$1

for i in $(seq 1 $nr_containers); do
    docker stop docker-vb-$i && docker rm docker-vb-$i
done
