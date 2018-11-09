#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: "$0" <job ID> <'s' or 'r'> <nr processes>"
    exit 2
fi

seed=$1
mode=$2
procs=$3

RESULTS_DIR=${HOME}/results
out_dir=${RESULTS_DIR}/${mode}/${seed}

outfile=mpirun.out
errfile=mpirun.err

# Clear .vb_os on all nodes 
hosts=`awk '{print $1}' ~/hostfile`
cur_dir=`pwd`
for h in ${hosts[@]}; do
    echo "Setting up container $h"
    ssh $h "sudo rm -rf $cur_dir/work-dir; mkdir -p $cur_dir/work-dir;"
    ssh $h "mkdir -p $out_dir && rm -f ${out_dir}/*"
done

pushd work-dir

`which mpirun` \
    --mca btl_tcp_if_include 172.20.0.0/24 \
    --mca oob_tcp_if_include 172.20.0.0/24 \
    -np $procs --hostfile ~/hostfile ~/varbench \
    -p n -m n \
    -k operating_system \
    ~/libsyzcorpus.json \
    $mode f 100 0 1 $out_dir $seed \
    2> $errfile \
    1> $outfile

mv *.csv *.xml $errfile $outfile $out_dir

popd
