#!/bin/bash
if [ $# -lt 2 ]; then
    echo "Usage: $0 <LOCAL> <REMOTE>"
    exit 1
fi

LOCAL=$1
REMOTE=$2

sudo ip link add vxlan100 type vxlan id 100 dstport 4789 local 10.0.6.${LOCAL} remote 10.0.6.${REMOTE} # dev enp13s0np0
sudo ip addr add 192.168.100.1/24 dev vxlan100
sudo ip link set vxlan100 up
ip addr show vxlan100