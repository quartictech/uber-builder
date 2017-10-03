#!/bin/sh
set -eu

IMAGE_NAME=${1}
shift

# See https://circleci.com/docs/2.0/building-docker-images/#mounting-folders
docker create \
    -e GOOGLE_CREDENTIALS \
    --name test ${IMAGE_NAME} /home/quartic/test/run_tests_internal.sh "$@"

# This permission change (along with the -a below) seems to be necessary to ensure
# the quartic user inside the container can write to the test directory.
chmod -R a+rw $(pwd)/test
docker cp -a $(pwd)/test test:/home/quartic/test
docker start -a test