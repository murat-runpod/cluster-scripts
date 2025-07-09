#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <LAST_OCTET>"
    exit 1
fi
LAST_OCTET=$1

for i in {0..7} ; do
	docker network connect --ip 10.66.${i}.${LAST_OCTET} ipvlan-net-${i} pod;
done;
