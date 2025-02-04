#!/bin/bash
# run-pod.sh

# Check if container exists and remove it
docker rm -f pod 2>/dev/null

# First create with external network and first VXLAN network
docker run -d \
    --name pod \
    --network ext-net \
    --network vxlan-net0 \
    --ip 172.18.1.10 \
    --gpus all \
    nvidia/cuda:12.4.0-base-ubuntu22.04 \
    sleep infinity

# Add other VXLAN networks
for i in $(seq 1 7); do
    docker network connect \
        --ip 172.18.$((i+1)).10 \
        vxlan-net$i \
        pod
done

# Wait a moment for networks to connect
sleep 2 

# Execute into bash
docker exec -it pod bash