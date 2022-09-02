FROM alpine

# ---------------------------
# Build-time variables

# These are available till the image is built.
# Specify using 'docker build --build-arg VERSION=1.1.0'
# Or in an 'args' block in docker-compose.yml

# optional ARG
ARG IMAGE_NAME=unnamed00
# Aside: Image name/tag used by 'docker build' cannot be in the Dockerfile
#  but can be in docker-compose.yml. So there's no meaningful way we
#  can use this variable in this build script or in the running container.

# required ARG
ARG IMAGE_VERSION
# ---------------------------

# ---------------------------
# (Container) run time variables

# These are available to the running container
# Can be overridden using 'docker run -e GREETING=Howdy' <img>
ENV GREETING=Hello_from_Dockerfile
# Take from ARG at build time, pass to ENV at container runtime
ENV IMAGE_NAME=${IMAGE_NAME}
ENV IMAGE_VERSION=${IMAGE_VERSION}
# ---------------------------

# ---------------------------
# Build process
RUN echo "Starting build.."
RUN echo "At build time, IMAGE_NAME=$IMAGE_NAME"

RUN mkdir /work
WORKDIR /work
ADD entrypoint.sh .

# ---------------------------

# ---------------------------
# Commands
# ---------------------------
# "Shell Form"
# CMD <cmd> => Gets called as /bin/sh -c <cmd>
# CMD echo "Hello World"

# "Exec Form" - preferred style for CMD/ENTRYPOINT instructions
# <instruction> ["executable", "param1", "param2", ..]
# Calls executable directly, and shell processing does not happen
# CMD ["/bin/echo", "$GREETING"]  # Echoes $GREETING, literally
# CMD ["/bin/sh", "-c", "echo $GREETING"]  # Works as expected

# The build-time variable gets passed on to the container, and thus gets burned in the image (but can be overridden
# by 'docker run -e IMAGE_NAME=something')
# CMD = default command, if no command specified on 'docker run'
# Only the last CMD found here is considered

# The simplest case is to do something like:
# CMD ["sh", "-c", "echo ${GREETING} FROM container launched from image ${IMAGE_NAME} with version ${IMAGE_VERSION}"] 
# But we demonstrate ENTRYPOINT below.

# ---------------------------
# Entrypoints 
# ---------------------------
# Unlike CMDs, Entrypoints cannot be ignored on invocation
# ENTRYPOINT ["/bin/sh", "-c"]  # implicit ENTRYPOINT that is used, but Docker users wanted to customize this.

# Default additional arguments can be supplied by using the Exec form of CMD (when using ENTRYPOINT, forget about the shell form of CMD)
# CMD ["foo", "bar"]

# Since we wish to capture ENV vars (visible as envvars to the shell), we use the shell form here
# See https://stackoverflow.com/questions/37904682/
# as well as a trick to pass CMD arguments to the shell form of ENTRYPOINT
# See https://stackoverflow.com/questions/42298177/
# ENTRYPOINT ./entrypoint.sh  # if we don't care about CMD arguments
ENTRYPOINT ./entrypoint.sh $0 $@

# Since we want to pass arguments to entrypoint on 'docker run', we NEED a CMD entry.
# But since we also don't want to use a made-up entry, we use "" here, and handle that case in entrypoint.sh
CMD [""]
