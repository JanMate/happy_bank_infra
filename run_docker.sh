#!/bin/bash

usage() {
  echo "Usage: ./run_docker username password"
  echo ""
  echo "  username - login name on docker hub"
  echo "  password - password on docker hub"
  echo ""
}

# Add validation to given arguments. If the parameters are not set or are empty, show usage message.
# TODO

username="$1"
password="$2"

# If you have no account on docker hub, sign up yourself. Then, login yourself to docker
# TODO

# Pull Alpine Linux (alpine:3.15.0) docker image
# TODO

# List docker images
# TODO

# Launch the docker image from previous step with 'ls -la /' command
# TODO

# Start a new container with pulled Alpine Linux image
# TODO

# List all running docker containers
# TODO

# List environment variables of running alpine container and the output store to 'env_vars' file in home directory in the running container
# TODO

# Copy 'clone_update_repo.sh' script from this repo to home directory in the running container
# TODO

# Show logs from the running container
# TODO

# Stop the running container
# TODO

# Create your own image named 'custom-alpine:0.0.1' from the stopped container
# TODO

# Create a new tag '0.0.2' of your new image
# TODO

# Push your new image to docker hub
# TODO

# Logout yourself from docker
# TODO
