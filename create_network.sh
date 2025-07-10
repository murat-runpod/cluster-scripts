docker network create \
	--driver=bridge \
	--subnet=10.65.0.0/24 \
	--gateway=10.65.0.1 \
	--opt com.docker.network.bridge.name=br-100 \
	mn-bridge
docker network connect mn-bridge safe_runpod_node
ip link add vxlan100 type vxlan id 100 dstport 4789
ip link set vxlan100 up
ip link set vxlan100 master br-100
bridge fdb append 00:00:00:00:00:00 dst 10.0.6.91 dev vxlan100 static permanent
