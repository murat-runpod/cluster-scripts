#!/bin/bash
docker run -d \
	--name safe_runpod_node \
	--network=bridge \
	--device=/dev/infiniband:/dev/infiniband \
	-v /sys/class/infiniband:/sys/class/infiniband:ro \
	--ulimit memlock=-1:-1 \
	pytorch/pytorch:2.7.1-cuda11.8-cudnn9-runtime \
	sleep infinity