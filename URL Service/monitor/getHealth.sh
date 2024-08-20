#!/bin/bash

check_health_on_node() {
    local NODE_IP=$1
    echo "Checking health status of urlShortener_web service on node: $NODE_IP"

    # Get the container ID of the service
    local CONTAINER_ID=$(ssh "$NODE_IP" "docker ps -f name=urlShortener_web --quiet")
    
    # Check if CONTAINER_ID is not empty
    if [ -n "$CONTAINER_ID" ]; then
        # Inspect the health status of the container
        local HEALTH_STATUS=$(ssh "$NODE_IP" "docker inspect --format '{{json .State.Health.Status}}' $CONTAINER_ID")
        echo "Container $CONTAINER_ID: $HEALTH_STATUS"
    else
        echo "No urlShortener_web container found on node $NODE_IP"
    fi

    echo "-------------------------------------"
}

IP_LIST=$(cat /home/student/a2group99/ip_list.txt)

for IP in $IP_LIST; do
    check_health_on_node "$IP"
done
