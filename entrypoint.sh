#!/bin/sh

# arguments supplied?
if [ $# -ge 1 ]
then
    # simply echo what was passed in
    echo $@ 
else
    # echo a message based on envvars
    echo ${GREETING} FROM container launched from image ${IMAGE_NAME} with version ${IMAGE_VERSION}
fi
