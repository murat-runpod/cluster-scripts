#!/bin/bash
if [ $# -lt 1 ]; then
    echo "Usage: $0 <LAST_OCTET>"
    exit 1
fi

LOCAL=$1

SUBNETS=(6 7 5 8 1 2 3 4)

for i in {0..7} ; do
    LINK=${SUBNETS[$i]}
    VNI=$((100 + i))
    VXLAN_NAME="vxlan${i}"

    ip link add ${VXLAN_NAME} type vxlan id ${VNI} group 239.0.0.10 dstport 4789 dev enp$((13+i))s0np0
    ip addr add 10.200.${i}.${LOCAL}/24 dev ${VXLAN_NAME}
    ip link set dev ${VXLAN_NAME} mtu 4150
    ip link set ${VXLAN_NAME} up
    ip -c -4 addr show ${VXLAN_NAME}
done;