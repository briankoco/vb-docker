#!/bin/bash

src_path=generated-files/varbench
vb_path=generated-files/files

if [ ! -d $src_path ] ; then
    echo "You must run ./setup.sh first"
    exit 1
fi

mkdir -p $vb_path

docker build --rm -t docker-vb-build -f Dockerfile.build -m 4g .
if [ $? -ne 0 ] ; then
    echo "Failed to build docker-vb-build container"
    exit 2
fi

docker create --name build-cont docker-vb-build
docker cp build-cont:/varbench/varbench $vb_path
docker cp build-cont:/varbench/src/kernels/corpuses/sample-corpus/libsyzcorpus.so $vb_path
docker cp build-cont:/varbench/src/kernels/corpuses/sample-corpus/libsyzcorpus.json $vb_path
docker rm build-cont

docker build --rm -t docker-vb .
