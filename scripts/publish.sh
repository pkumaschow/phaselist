#!/bin/bash

set -euo pipefail
docker login -u ${USER_NAME} -p ${USER_PASSWORD}
docker push pkumaschow/phaselist
