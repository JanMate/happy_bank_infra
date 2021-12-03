#!/bin/bash

# Added color variables
red='\033[0;31m'
nc='\033[0m'

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
  if [[ -f ~/docker_username && -f ~/docker_token ]]; then
    username=$(cat ~/docker_username)
    password=$(cat ~/docker_token)
  else
    usage
    exit
  fi
fi

# If you have no account on docker hub, sign up yourself. Then, login yourself to docker
echo -e "${red}Logging in to Docker hub${nc}"
echo "Username: $username"
echo -n "$password" | docker login --username="$username" --password-stdin

# Pull Alpine Linux (alpine:3.15.0) docker image
echo -e "${red}Pulling docker image${nc}"
image_name=alpine:3.15.0
docker pull "$image_name"

# List docker images
echo -e "${red}List docker images${nc}"
docker images

# Launch the docker image from previous step with 'ls -la /' command
# TODO

# Start a new container with pulled Alpine Linux image
echo -e "${red}Starting new container with pulled image${nc}"
container_name=my_container
docker run -it -d --name "$container_name" "$image_name"

# List all running docker containers
echo -e "${red}List running containers${nc}"
docker ps

# List environment variables of running alpine container and the output store to 'env_vars' file in home directory in the running container
echo -e "${red}List env variables of running container and save it to the file${nc}"
env_variables=$(docker exec "$container_name" env)
docker exec "$container_name" sh -c "echo '$env_variables' >> home/env_vars"
docker exec "$container_name" cat home/env_vars


# Copy 'clone_update_repo.sh' script from this repo to home directory in the running container
echo -e "${red}Copying file from host to container${nc}"
docker cp clone_update_repo.sh "$container_name":home
docker exec "$container_name" ls home

# Show logs from the running container
echo -e "${red}Logs from the running container:${nc}"
docker logs "$container_name"

# Stop the running container
echo -e "${red}Stop the container${nc}"
docker stop -t 1 "$container_name"

# Create your own image named 'custom-alpine:0.0.1' from the stopped container
echo -e "${red}Creating custom image with tag${nc}"
default_tag=oleksandr6676/custom-alpine:0.0.1
docker commit "$container_name" "$default_tag"
docker images

# Create a new tag '0.0.2' of your new image
echo -e "${red}Creating new tag for custom image${nc}"
updated_tag=oleksandr6676/custom-alpine:0.0.2
docker tag "$default_tag" "$updated_tag"
docker images

# Push your new image to docker hub
echo -e "${red}Pushing new image to docker hub${nc}"
docker push "$updated_tag"

# Logout yourself from docker
echo -e "${red}Logged out${nc}"
docker logout
