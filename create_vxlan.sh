#!/bin/bash

SUBNETS=(6 7 5 8 1 2 3 4)

for i in {0..7} ; do
    LINK=${SUBNETS[$i]}
    VNI=$((100 + i))
    VXLAN_NAME="vxlan${i}"

    ip link add ${VXLAN_NAME} type vxlan id ${VNI} dstport 4789 dev enp$((13+i))s0np0
    ip link set ${VXLAN_NAME} up
    ip -c -br addr show ${VXLAN_NAME}
done;