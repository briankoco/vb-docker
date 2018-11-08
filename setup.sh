#!/bin/bash

mkdir -p generated-files
mkdir -p ssh-keys

pushd generated-files
git clone https://github.com/briankoco/varbench.git
popd

pushd ssh-keys
ssh-keygen -t rsa -f id_rsa.vb -N ''
echo "Host *" > config
echo "    StrictHostKeyChecking no" >> config
chmod 644 config
popd
