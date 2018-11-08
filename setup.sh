#!/bin/bash

mkdir -p generated-files
mkdir -p ssh-keys

pushd generated-files
if [ ! -d varbench ]; then 
    git clone https://github.com/briankoco/varbench.git
else
    git pull
fi
popd

pushd ssh-keys
ssh-keygen -t rsa -f id_rsa.vb -N ''
echo "Host *" > config
echo "    StrictHostKeyChecking no" >> config
chmod 644 config
popd

docker network create --subnet=172.20.0.0/24 vb-net &> /dev/null
