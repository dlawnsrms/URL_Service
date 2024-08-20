WORKER_IP=$1

WORKER_JOIN_TOKEN=$(docker swarm join-token -q worker)
ssh "$WORKER_IP" "docker swarm leave --force"
ssh "$WORKER_IP" "docker swarm join --token $WORKER_JOIN_TOKEN $MANAGER_IP1:2377"