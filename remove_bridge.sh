#!/bin/bash
docker network disconnect mn-bridge safe_runpod_node
docker network rm mn-bridge
ip link delete vxlan100
