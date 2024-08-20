# https://docs.docker.com/engine/reference/builder/

# Use an official Python runtime as a parent image
# See https://hub.docker.com/ and search for python:2.7-slim
FROM python:3.11-slim

# Set the working directory to /app
# The WORKDIR instruction sets the working directory (inside the container) 
# for any RUN, CMD, ENTRYPOINT, COPY and ADD instructions that 
# follow it in the Dockerfile. 
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD ./app /app

# Install any needed packages specified in requirements.txt
# RUN during image build
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run python app.py when the container launches
# This happens if no command is specified
CMD ["python3", "app.py"]

# Healthcheck to ensure the service is running
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1