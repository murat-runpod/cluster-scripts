#!/bin/bash
# cleanup-vxlan.sh

# Stop and remove all containers
docker ps -q | xargs -r docker rm -f

# Remove all networks
for net in $(docker network ls --filter name=vxlan --format "{{.Name}}"); do
    docker network rm $net
done
docker network rm ext-net 2>/dev/null

# Remove all VXLAN interfaces and bridges
for i in $(seq 0 7); do
    sudo ip link del vxlan$i 2>/dev/null
done

# Show status
echo "Remaining interfaces:"
ip link show | grep vxlan
bridge fdb show | grep vxlan
docker network ls | grep vxlan