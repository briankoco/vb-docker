#!/bin/bash


if [ $# -lt 2 ]; then
    echo "Usage: "$0" <nr containers> <nr cores total>"
    exit 2
fi

nr_containers=$1
nr_cores_total=$2

if [ $(($nr_cores_total % $nr_containers)) -ne 0 ]; then
    echo "Number of containers must be a factor of number of cores"
    exit 2
fi
nr_cores_per_container=$(($2 / $1))

NODE0_CPUS="0,32,8,40,16,48,24,56,4,36,12,44,20,52,28,60"
NODE1_CPUS="1,33,9,41,17,49,25,57,5,37,13,45,21,53,29,61"
NODE2_CPUS="2,34,10,42,18,50,26,58,6,38,14,46,22,54,30,62"
NODE3_CPUS="3,35,11,43,19,51,27,59,7,39,15,47,23,55,31,63"


rm -f hostfile
for i in $(seq 1 $nr_containers); do
    val=$((10 + $i)) 
    ip=172.20.0.$val

    ## TODO: begin hack ##
#    if [ $i -eq 1 ]; then
#        DOCKER_OPTS="--cpuset-cpus ${NODE0_CPUS} --cpuset-mems 0"
#    elif [ $i -eq 2 ]; then
#        DOCKER_OPTS="--cpuset-cpus ${NODE1_CPUS} --cpuset-mems 1"
#    elif [ $i -eq 3 ]; then
#        DOCKER_OPTS="--cpuset-cpus ${NODE2_CPUS} --cpuset-mems 2"
#    else
#        DOCKER_OPTS=""
#    fi

#    echo $DOCKER_OPTS
    DOCKER_OPTS="--cpus $nr_cores_per_container"

    docker run --net vb-net --ip $ip --name=docker-vb-$i \
        $DOCKER_OPTS \
        -d docker-vb

    #-v /ssd-sdb/briankoco:/ssd-data/ 

    echo "$ip slots=$nr_cores_per_container max-slots=$nr_cores_per_container" >> hostfile
done

# Copy in the hostfile to the head container
echo "docker cp hostfile docker-vb-1:hostfile"
docker cp hostfile docker-vb-1:/home/cc/hostfile
