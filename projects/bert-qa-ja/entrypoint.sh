#!/bin/bash

USER_ID=${LOCAL_UID:-9001}
GROUP_ID=${LOCAL_GID:-9001}
NAME=${LOCAL_USER:-user}

echo "Starting with UID: ${USER_ID}, GID: ${GROUP_ID}, NAME: ${NAME}"
useradd -u ${USER_ID} -o -m ${NAME}
groupmod -g ${GROUP_ID} ${NAME}
export HOME=/home/${NAME}

# Exec commands recieved as docker run arguments
exec "$@"