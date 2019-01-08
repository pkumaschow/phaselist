#!/bin/bash

set -euo pipefail
docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"
docker push pkumaschow/phaselist
