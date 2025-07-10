#!/bin/bash
docker network disconnect rm-bridge safe_runpod_node
docker network rm mn-bridge
ip link delete vxlan100
