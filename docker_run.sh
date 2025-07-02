docker run -d \
	--name pod \
	--gpus all \
	--network=mn-bridge \
	--ip 10.65.0.2 \
	--device=/dev/infiniband/uverbs0:/dev/infiniband/uverbs0 \
	-v /sys/class/infiniband:/sys/class/infiniband:ro \
	--ulimit memlock=-1:-1 \
	pytorch/pytorch:2.7.1-cuda11.8-cudnn9-runtime \
	sleep infinity &&
docker exec -it pod bash
