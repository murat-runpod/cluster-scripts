#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: $0 <SUBNET> <LAST_OCTET>"
    exit 1
fi

SUBNET=$1
LAST_OCTET=$2

for i in {0..7} ; do
	docker network create -d ipvlan --subnet 10.${SUBNET}.${i}.0/24 --label "multi-node" -o parent=enp$((i+13))s0np0 ipvlan-net-${i};
	docker network connect --ip 10.${SUBNET}.${i}.${LAST_OCTET} ipvlan-net-${i} safe_runpod_node;
done;
