#!/bin/sh

# Shell
docker-compose up -d

# Wait some seconds for service Up
sleep 5

# Manager1 init
docker-compose exec manager1 docker swarm init
tokenworker=$(docker-compose exec manager1 docker swarm join-token worker | grep -- "--token " | awk '{print $2}')
tokenmanager=$(docker-compose exec manager1 docker swarm join-token manager | grep -- "--token " | awk '{print $2}')

# Manager2 join
docker-compose exec manager2 docker swarm join --token $tokenmanager manager1:2377

# Worker1 join
docker-compose exec worker1 docker swarm join --token $tokenworker manager1:2377

# Worker2 join
docker-compose exec worker2 docker swarm join --token $tokenworker manager1:2377

# Deploy portainer
ipmanager1=$(docker-compose exec manager1 ifconfig eth0 | grep "inet addr:" | awk -F":" '{print $2}' | awk '{print $1}')
ipmanager2=$(docker-compose exec manager2 ifconfig eth0 | grep "inet addr:" | awk -F":" '{print $2}' | awk '{print $1}')
ipworker1=$(docker-compose exec worker1 ifconfig eth0 | grep "inet addr:" | awk -F":" '{print $2}' | awk '{print $1}')
ipworker2=$(docker-compose exec worker2 ifconfig eth0 | grep "inet addr:" | awk -F":" '{print $2}' | awk '{print $1}')
docker-compose exec manager1 docker service create -p 9000:9000 --name portainer --host manager1:$ipmanager1 --host manager2:$ipmanager2 --host worker1:$ipworker1 --host worker2:$ipworker2 --mount type=bind,source=/endpoints.json,target=/endpoints.json portainer/portainer --external-endpoints /endpoints.json

# Deploy 6 istrances of whoami
docker-compose exec manager1 docker service create --name whoami -p 9001:80 --replicas=6 emilevauge/whoami
