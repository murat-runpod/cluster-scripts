for i in {0..7} ; do
	docker network create -d macvlan --subnet 10.65.${i}.0/24 -o parent=enp${i+13}s0np0 macvlan-net-${i};
done;
