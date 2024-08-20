#!/bin/bash

# Read IPs from node_ips.txt and store them in an array
IFS=$'\n' read -d '' -r -a ips < ip_list.txt

# Check if at least one IP address is present
if [ ${#ips[@]} -eq 0 ]; then
    echo "No IP addresses found in ip_list.txt"
    exit 1
fi

# Starting the Cassandra cluster and swarm with all IPs
./cassandra/startCluster "${ips[@]}"
./startSwarm.sh "${ips[@]}"

cd nginx-dockerfile

docker build -t rayhanfazal/nginx-image:nginx-tag .
docker push rayhanfazal/nginx-image:nginx-tag

cd ..

docker build -t rayhanfazal/url_shortner_test:v1 .
docker push rayhanfazal/url_shortner_test:v1

docker pull dockersamples/visualizer

docker stack deploy -c docker-compose.yml urlShortener
