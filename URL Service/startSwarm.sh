#!/bin/bash

USAGE="Usage: $0 MANAGER_IP1 MANAGER_IP2 MANAGER_IP3 [WORKER_IP1] [WORKER_IP2] ..."

# Check if at least 3 IP addresses are provided
if [ "$#" -lt "3" ]; then
    echo "$USAGE"
    exit 1
fi

MANAGER_IP1="$1"
docker swarm leave --force
docker swarm init --advertise-addr "$MANAGER_IP1"
MANAGER_JOIN_TOKEN=$(docker swarm join-token -q manager)

MANAGER_IP2="$2"
echo "Manager $MANAGER_IP2 joining the swarm..."
ssh "$MANAGER_IP2" "docker swarm leave --force"
ssh "$MANAGER_IP2" "docker swarm join --token $MANAGER_JOIN_TOKEN $MANAGER_IP1:2377"

MANAGER_IP3="$3"
echo "Manager $MANAGER_IP3 joining the swarm..."
ssh "$MANAGER_IP3" "docker swarm leave --force"
ssh "$MANAGER_IP3" "docker swarm join --token $MANAGER_JOIN_TOKEN $MANAGER_IP1:2377"

# Remaining IPs, if any, are workers
shift 3
WORKER_JOIN_TOKEN=$(docker swarm join-token -q worker)
for WORKER_IP in "$@"; do
    echo "Worker $WORKER_IP joining the swarm..."
    ssh "$WORKER_IP" "docker swarm leave --force"
    ssh "$WORKER_IP" "docker swarm join --token $WORKER_JOIN_TOKEN $MANAGER_IP1:2377"
done

echo "Swarm cluster initialized"
