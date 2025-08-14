#!bin/bash


if [ $# -lt 1 ]; then
    echo "Usage: $0 <TARGET_HOST_OCTET>"
    exit 1
fi

TARGET_HOST_OCTET=$1

SUBNETS=(6 7 5 8 1 2 3 4)
for i in {0..7} ; do
    LINK=${SUBNETS[$i]}
    VXLAN_NAME="vxlan${i}"
    bridge fdb append 00:00:00:00:00:00 dev ${VXLAN_NAME} dst 10.0.${LINK}.${TARGET_HOST_OCTET} self permanent;
    bridge -c fdb show dev vxlan${i};
done;

