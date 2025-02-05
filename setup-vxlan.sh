#!/bin/bash
# setup-vxlan.sh

# Clean up first
./cleanup-vxlan.sh

# Create external network for internet access
docker network create --driver bridge \
    --opt com.docker.network.bridge.name=ext-br \
    --subnet 172.19.0.0/24 \
    ext-net

# Create 8 separate networks, each with dedicated NIC
for i in $(seq 0 7); do
    iface="enp$((13 + i))s0np0"
    remote_ip="10.0.$((i + 1)).44"  # Change to .64 for server 2
    
    # Create docker network with dedicated bridge
    docker network create --driver bridge \
        --opt com.docker.network.driver.mtu=4150 \
        --opt com.docker.network.bridge.name=vxlan-br$i \
        --subnet 172.18.$((i+1)).0/24 \
        vxlan-net$i

    # Create VXLAN interface bound to specific NIC
    sudo ip link add vxlan$i type vxlan \
        id $((100 + i)) \
        dstport $((4789 + i)) \ 
        dev $iface \ 
        local $(ip addr show $iface | grep -Po 'inet \K[\d.]+') \
        nolearning

    # Setup VXLAN interface
    sudo ip link set vxlan$i mtu 4150
    sudo ip link set vxlan$i up
    sudo ip link set vxlan$i master vxlan-br$i

    # Add FDB entry for this specific path
    sudo bridge fdb append 00:00:00:00:00:00 dev vxlan$i dst $remote_ip
done

echo "Setup complete. Created networks:"
docker network ls | grep vxlan