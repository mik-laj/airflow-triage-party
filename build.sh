#!/bin/bash

set -euox pipefail

PRIJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

cd "${PRIJECT_ROOT}" || exit 1

source "_common_variables.sh"

BASE_IMAGE="raw-triage-party:latest"

docker build triage-party \
    --tag="${BASE_IMAGE}"

docker build . \
    --tag="${FULL_IMAGE_NAME}"\
    --build-arg "BASE_IMAGE=${BASE_IMAGE}" \
    --file=Dockerfile.prod
