#!/bin/bash

for i in {0..7}; do
    ip link delete vxlan${i}
    echo "Deleted vxlan${i}"
done;