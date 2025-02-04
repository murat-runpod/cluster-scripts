#!/bin/bash
# setup-vxlan.sh

# Clean up first
./cleanup-vxlan.sh

# Create external network for internet access
docker network create --driver bridge \
    --opt com.docker.network.bridge.name=ext-br \
    --subnet 172.19.0.0/24 \
    ext-net

# Create 8 separate networks for NCCL
for i in $(seq 0 7); do
    vni=$((100 + i))
    iface="enp$((13 + i))s0np0"
    remote_ip="10.0.$((i + 1)).44"  # Change to .64 for server 2
    net_name="vxlan-net$i"
    
    # Create docker network with specific bridge name
    docker network create --driver bridge \
        --opt com.docker.network.driver.mtu=4150 \
        --opt com.docker.network.bridge.name=vxlan-br$i \
        --subnet 172.18.$((i+1)).0/24 \
        $net_name

    # Create VXLAN interface
    sudo ip link add vxlan$i type vxlan \
        id $vni \
        dstport 4789 \
        dev $iface

    sudo ip link set vxlan$i mtu 4150
    sudo ip link set vxlan$i up
    sudo ip link set vxlan$i master vxlan-br$i

    # Add FDB entry
    sudo bridge fdb append 00:00:00:00:00:00 dev vxlan$i dst $remote_ip
done

echo "Setup complete. Created networks:"
docker network ls | grep vxlan
docker network ls | grep ext-net