#!/bin/bash
for i in {0..7} ; do
	docker network create -d ipvlan --subnet 10.66.${i}.0/24 --label "multi-node" -o parent=enp$((i+13))s0np0 ipvlan-net-${i};
done;
