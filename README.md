# URL_Service

# Project Overview
This repository contains the architecture and implementation details for a distributed system designed with a focus on consistency, availability, and partition tolerance. Below is an overview of the system's core components, along with key aspects such as data flow, monitoring, scalability, and disaster recovery.

# System Architecture
The system is composed of several VMs hosting various services, including Cassandra for data storage, Redis for caching, and Docker containers for application deployment.

# Application System: The application is deployed using Docker Swarm across multiple VMs, ensuring redundancy and scalability. Nginx is employed for load balancing, distributing incoming requests across the system.

# Monitoring System: A dedicated VM runs the monitoring script (monitor.sh), which checks the health of the Cassandra cluster, Docker containers, and Docker Swarm. It utilizes Docker Health Check and outputs the status to an HTML file for easy monitoring.

# Data Flow: Data is primarily stored in Redis and Cassandra instances. Redis is configured for caching with one primary and two secondary nodes, while Cassandra handles data persistence with a replication factor of 2, ensuring data consistency and availability across nodes.

# Key Features
# Consistency
Consistency is maintained by utilizing Redis and Cassandra, both configured to store the latest data versions across all nodes. This ensures that all data remains consistent across the system.

# Availability
The system guarantees high availability through data replication. Cassandra's replication factor and Redis's primary-secondary setup ensure that data remains accessible even in the event of node failures.

# Partition Tolerance
The system is designed to tolerate partitioning by allowing continuous operation despite the failure of individual nodes. Redis and Cassandra nodes are distributed across separate VMs, ensuring the system remains functional even if some containers or VMs fail.

# Data Replication
Data replication is achieved via Cassandra's configuration, where data is replicated across multiple nodes, ensuring redundancy. Redis similarly replicates data across primary and secondary nodes.

# Load Balancing
Nginx is configured to handle load balancing, distributing incoming traffic across the Docker Swarm, ensuring efficient resource utilization and avoiding overload on any single node.

# Caching
Caching is implemented using Redis, configured with a primary node and two secondary nodes. This setup enhances performance by storing frequently accessed data in memory, with a Least Recently Used (LRU) eviction policy to manage memory usage effectively.

# Disaster Recovery
The system incorporates disaster recovery mechanisms through data replication in Redis and Cassandra. In case of node failure, data can be recovered from replicated nodes, minimizing downtime and data loss.

# Horizontal Scalability
Horizontal scalability is enabled via the start.sh script, which allows the addition of new nodes specified in the ip_lists.txt file. This enables the system to scale by adding more VMs to the cluster.

# Health Check and Monitoring
The monitor.sh script runs continuous health checks on the system's components, including Docker containers and the Cassandra cluster. The health status is logged and can be visualized using Docker Visualizer

# Running the System
To run the system, follow these steps:

SSH into the appropriate VM.
Execute the start.sh script to initialize the Cassandra cluster, Docker Swarm, and other services.
To interact with the system, use curl commands to send requests to the Nginx server, which listens on port 4001.
To view the Docker visualizer, set up port forwarding and access it via your browser.
Stopping the System
To shut down the system, run the stop.sh script from within the first VM. This script will stop all running Docker containers, halt the Cassandra cluster, and tear down the Docker Swarm.

# Testing the System
Performance testing can be conducted using the provided LoadTest scripts located in the performanceTesting/ directory.

This README provides a high-level overview of the system architecture, its key components, and how to run, monitor, and test the system. For detailed information, refer to the respective sections in the documentation.
