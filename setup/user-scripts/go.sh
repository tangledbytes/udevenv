#!/bin/bash

cd /tmp
sudo rm -rf /usr/local/go
wget https://go.dev/dl/${GOVERSION}.linux-${TARGETARCH}.tar.gz 
sudo tar -C /usr/local -xzf ${GOVERSION}.linux-${TARGETARCH}.tar.gz
echo "export PATH=/usr/local/go/bin:$PATH" >> /home/${USERNAME}/.zshenv 
rm -rf ${GOVERSION}.linux-$TARGETARCH.tar.gz