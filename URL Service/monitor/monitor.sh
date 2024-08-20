#!/bin/bash

INTERVAL=60

while true; do
    echo "<html>\n<body>" > output.html
    echo "<h1>Cassandra Cluster Status</h1>" >> output.html

    docker exec -it cassandra-node nodetool status > cassandra_output.txt

    while IFS= read -r line; do
        echo "<div>$line</div>\n" >> output.html
    done < cassandra_output.txt

    echo "<h1>Container Status</h1>" >> output.html
    docker container ls > container_output.txt
    while IFS= read -r line 
    do
        echo "<div>$line</div>" >> output.html
    done < container_output.txt

    echo "<h1>Swarm Status</h1>" >> output.html
    docker node ls > swarm_output.txt
    while IFS= read -r line 
    do
        echo "<div>$line</div>" >> output.html
    done < swarm_output.txt

    chmod u+x getHealth.sh
    ./getHealth.sh >> output.html

    echo "</body></html>" >> output.html

    sleep $INTERVAL
done
