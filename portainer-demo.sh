#!/bin/sh

# Up all dinds nodes
docker-compose up -d manager1 manager2 worker1 worker2

# Wait some seconds for service Up
sleep 5

# Manager1 init
docker-compose exec manager1 docker swarm init
tokenworker=$(docker-compose exec manager1 docker swarm join-token -q worker)
tokenmanager=$(docker-compose exec manager1 docker swarm join-token -q manager)

# Manager2 join
docker-compose exec manager2 docker swarm join --token $tokenmanager manager1:2377

# Worker1 join
docker-compose exec worker1 docker swarm join --token $tokenworker manager1:2377

# Worker2 join
docker-compose exec worker2 docker swarm join --token $tokenworker manager1:2377

# Up portainer
docker-compose up -d portainer

# Deploy 6 instances of whoami
docker-compose exec manager1 docker service create --name whoami -p 80:80 --replicas=6 emilevauge/whoami
