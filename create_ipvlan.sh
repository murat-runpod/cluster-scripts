#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <LAST_OCTET>"
    exit 1
fi
LAST_OCTET=$1

for i in {0..7} ; do
	docker network create -d ipvlan --subnet 10.66.${i}.0/24 --label "multi-node" -o parent=enp$((i+13))s0np0 ipvlan-net-${i};
	docker network connect --ip 10.66.${i}.${LAST_OCTET} ipvlan-net-${i} safe_runpod_node;
done;
