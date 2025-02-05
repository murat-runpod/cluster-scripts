#!/bin/bash
# setup-vxlan.sh for node 1 (10.0.X.44)

# Clean up first
./cleanup-vxlan.sh

# Create external network for internet access
docker network create --driver bridge \
   --opt com.docker.network.bridge.name=ext-br \
   --subnet 172.19.0.0/24 \
   ext-net

# Create 8 separate networks, each with dedicated NIC
for i in $(seq 0 7); do
   # Define interface and IPs
   iface="enp$((13 + i))s0np0"
   local_ip=$(ip addr show $iface | grep -Po "inet \K10.0.$((i + 1))\.[0-9]+")
   remote_ip1="10.0.$((i + 1)).64"  # Node 2
   remote_ip2="10.0.$((i + 1)).48"  # Node 3
   remote_ip3="10.0.$((i + 1)).58"  # Node 4
   vni=$((100 + i))
   dstport=$((4789 + i))
   
   # Create docker network with dedicated bridge
   docker network create --driver bridge \
       --opt com.docker.network.driver.mtu=4150 \
       --opt com.docker.network.bridge.name=vxlan-br$i \
       --subnet 172.18.$((i+1)).0/24 \
       vxlan-net$i

   # Create VXLAN interface bound to specific NIC
   sudo ip link add vxlan$i type vxlan \
       id $vni \
       dstport $dstport \
       dev $iface \
       local $local_ip \
       nolearning

   # Setup VXLAN interface
   sudo ip link set vxlan$i mtu 4150
   sudo ip link set vxlan$i up
   sudo ip link set vxlan$i master vxlan-br$i

   # Add FDB entries for all remote nodes
   sudo bridge fdb append 00:00:00:00:00:00 dev vxlan$i dst $remote_ip1
   sudo bridge fdb append 00:00:00:00:00:00 dev vxlan$i dst $remote_ip2
   sudo bridge fdb append 00:00:00:00:00:00 dev vxlan$i dst $remote_ip3
done

echo "Setup complete. Created networks:"
docker network ls | grep vxlan