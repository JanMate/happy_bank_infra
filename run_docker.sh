#!/bin/bash

# Added color constants
RED='\033[0;31m'
NC='\033[0m'

usage() {
  echo "Usage: ./run_docker username password"
  echo ""
  echo "  username - login name on docker hub"
  echo "  password - password on docker hub"
  echo ""
}

# Add validation to given arguments. If the parameters are not set or are empty, show usage message.
username="$1"
password="$2"

if [[ -z "$username" || -z "$password" ]]; then
  usage
  exit
fi

# If you have no account on docker hub, sign up yourself. Then, login yourself to docker
echo -e "${RED}Logging in to Docker hub${NC}"
echo -n "$password" | docker login --username="$username" --password-stdin

# Pull Alpine Linux (alpine:3.15.0) docker image
echo -e "${RED}Pulling docker image${NC}"
image_name=alpine:3.15.0
docker pull "$image_name"

# List docker images
echo -e "${RED}List docker images${NC}"
docker images

# Launch the docker image from previous step with 'ls -la /' command
echo -e "${RED}Starting container with ls -la command${NC}"
docker run "$image_name" ls -la

# Start a new container with pulled Alpine Linux image
echo -e "${RED}Starting new container with pulled image${NC}"
container_name=my_container
docker run --name "$container_name" -d "$image_name" sh -c "while true; do echo 'Show me some logs'; sleep 1; done"

# List all running docker containers
echo -e "${RED}List running containers${NC}"
docker ps

# List environment variables of running alpine container and the output store to 'env_vars' file in home directory in the running container
echo -e "${RED}List env variables of running container and save it to the file${NC}"
env_variables=$(docker exec "$container_name" env)
docker exec "$container_name" sh -c "echo '$env_variables' >> home/env_vars"
docker exec "$container_name" cat home/env_vars


# Copy 'clone_update_repo.sh' script from this repo to home directory in the running container
echo -e "${RED}Copying file from host to container${NC}"
docker cp clone_update_repo.sh "$container_name":home
docker exec "$container_name" ls home

# Show logs from the running container
echo -e "${RED}Logs from the running container:${NC}"
docker logs "$container_name"

# Stop the running container
echo -e "${RED}Stop the container${NC}"
docker stop -t 1 "$container_name"

# Create your own image named 'custom-alpine:0.0.1' from the stopped container
echo -e "${RED}Creating custom image with tag${NC}"
default_tag="$username/custom-alpine:0.0.1"
docker commit "$container_name" "$default_tag"
docker images

# Create a new tag '0.0.2' of your new image
echo -e "${RED}Creating new tag for custom image${NC}"
updated_tag="$username/custom-alpine:0.0.2"
docker tag "$default_tag" "$updated_tag"
docker images

# Push your new image to docker hub
echo -e "${RED}Pushing new image to docker hub${NC}"
docker push "$updated_tag"

# Logout yourself from docker
echo -e "${RED}Logged out${NC}"
docker logout
