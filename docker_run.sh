#!/bin/bash
docker run -d \
	--name safe_runpod_node \
	--network=bridge \
	--device=/dev/infiniband:/dev/infiniband \
	-v /sys/class/infiniband:/sys/class/infiniband:ro \
	--ulimit memlock=-1:-1 \
	runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04 \
	sleep infinity