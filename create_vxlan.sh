#!/bin/bash
if [ $# -lt 3 ]; then
    echo "Usage: $0 <LOCAL> <REMOTE> <OCTET>"
    exit 1
fi

LOCAL=$1
REMOTE=$2
OCTET=$3

ip link add vxlan100 type vxlan id 100 dstport 4789 local 10.0.6.${LOCAL} remote 10.0.6.${REMOTE} # dev enp13s0np0
ip addr add 192.168.100.${OCTET}/24 dev vxlan100
ip link set dev vxlan100 mtu 4200
ip link set vxlan100 up
ip addr show vxlan100