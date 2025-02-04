#!/bin/bash
# run-pod.sh

# Check if container exists and remove it
docker rm -f pod 2>/dev/null

# First create container on external network
docker run -d \
    --name pod \
    --network ext-net \
    --gpus all \
    nvidia/cuda:12.4.0-base-ubuntu22.04

# Add all VXLAN networks
for i in $(seq 0 7); do
    docker network connect \
        --ip 172.18.$((i+1)).10 \
        vxlan-net$i \
        pod
done

# Wait a moment for networks to connect
sleep 2

# Execute into bash
docker exec -it pod bash