#!/bin/bash

for IP in "$@"; do
    echo "Removing node at $IP from swarm"
    ssh $IP "docker swarm leave --force"
done

echo "Swarm cluster stopped"
