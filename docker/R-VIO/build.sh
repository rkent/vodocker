#!/bin/bash

#https://stackoverflow.com/questions/59895/how-to-get-the-source-directory-of-a-bash-script-from-within-the-script-itself
DIRNAME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$DIRNAME/../config.sh"
NAME=$(basename $DIRNAME)
NAME_LOWER=$(echo "${NAME}" | tr '[:upper:]' '[:lower:]')

docker build -t ${BASE_NAME}/${NAME_LOWER}:latest -f Dockerfile ../../

