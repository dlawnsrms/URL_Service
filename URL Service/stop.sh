#!/bin/bash

# Read IPs from ip.txt and store them in an array
IFS=$'\n' read -d '' -r -a ips < ip_list.txt

# Check if at least one IP address is present
if [ ${#ips[@]} -eq 0 ]; then
    echo "No IP addresses found in ip_list.txt"
    exit 1
fi

docker stack rm urlShortener

./cassandra/stopCluster "${ips[@]}"
./stopSwarm.sh "${ips[@]}"
