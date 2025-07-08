for i in {0..7} ; do
	docker network connect macvlan-net-${i} pod;
done;
