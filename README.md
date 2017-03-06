# portainer-demo
Demo of portainer in swarm mode in dind  
You can test on http://play-with-docker.com  
  
Usage :
```
git clone https://github.com/WTFKr0/portainer-demo.git
cd portainer-demo
./portainer-demo.sh
```

This will launch 4 dind containers in swarm mode (2 managers / 2 workers)  
A portainer service will be expose on port 19000  
A whoami service will be exposed on port 19001  
