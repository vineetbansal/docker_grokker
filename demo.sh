#!/bin/bash

# In the next 3 cases, Dockerfile doesn't know about IMAGE_VERSION since docker-compose
# never passed it on.

echo "Forcing rebuild using docker-compose, and run"
docker-compose up --build
# Wazza_from_env_file FROM container launched from image echo with version

echo "Running container echo:0.0.0 that was built earlier"
docker run echo:0.0.0
# Hello_from_Dockerfile FROM container launched from image echo with version

echo "Running container echo:0.0.0 that was built earlier, with ENV vars overridden"
docker run -e "GREETING=Howdy_from_bash_script" echo:0.0.0
# Howdy_from_bash_script FROM container launched from image echo with version

# From this point on, we use 'docker build'

echo "Rebuilding container with docker build, with tag echo:0.0.1"
# We pass IMAGE_VERSION but not IMAGE_NAME
docker build --no-cache --build-arg IMAGE_VERSION=0.0.1 . -t echo:0.0.1

echo "Running container echo:0.0.1"
docker run echo:0.0.1 
# Hello_from_Dockerfile FROM container launched from image unnamed00 with version 0.0.1

echo "Rebuilding properly, with docker build, with tag echo:1.0.0"
# Why do we have to specify these twice below? One is for image build time, another for container runtime
# I don't know of any way where a running container can determine what image/tag it was built from.
docker build --no-cache --build-arg IMAGE_NAME=echo --build-arg IMAGE_VERSION=1.1.0 . -t echo:1.1.0

echo "Running container echo:1.1.0"
docker run echo:1.1.0
# Hello_from_Dockerfile FROM container launched from image echo with version 1.1.0

echo "Running echo:1.1.0 with overridden greeting"
docker run -e "GREETING=Howdy_from_bash_script" echo:1.1.0
# Howdy_from_bash_script FROM container launched from image echo with version 1.1.0

# CLEANEST WAY - env_file is available to both docker-compose.yml, and to the host to pass stuff to running container
echo "Running echo:1.1.0 with variables from env_file"
docker run --env-file=echo.env echo:1.1.0
# Wazza_from_env_file FROM container launched from image echo with version 1.1.0

# Other helpful stuff

# Remove all stopped containers
# docker container prune

# Remove specific images
# docker rmi echo:0.0.0

# Remove any dangling images not referenced by running/stopped containers
# docker rmi $(docker images -f "dangling=true" -q)
