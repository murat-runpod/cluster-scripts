#!/bin/bash
if [ $# -lt 2 ]; then
    echo "Usage: $0 <LOCAL> <REMOTE>"
    exit 1
fi

LOCAL=$1
REMOTE=$2

SUBNETS=(6 7 5 8 1 2 3 4)

for i in {0..7} ; do
    LINK=${SUBNETS[$i]}
    VNI=$((100 + i))
    VXLAN_NAME="vxlan${i}"

    ip link add ${VXLAN_NAME} type vxlan id ${VNI} dstport 4789 local 10.0.${LINK}.${LOCAL} remote 10.0.${LINK}.${REMOTE}
    ip addr add 192.168.${i}.${LOCAL}/24 dev ${VXLAN_NAME}
    ip link set dev ${VXLAN_NAME} mtu 4150
    ip link set ${VXLAN_NAME} up
    ip addr show ${VXLAN_NAME}
done;