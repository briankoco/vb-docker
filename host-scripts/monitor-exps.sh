#!/bin/bash

ip="172.20.0.11"

while [ 1 -eq 1 ]; do
    clear
    ssh -l cc -i ../ssh-keys/id_rsa.vb $ip "tail -n 30 scripts/work-dir/mpirun.out && grep seed scripts/work-dir/mpirun.out"
    sleep 5
done
