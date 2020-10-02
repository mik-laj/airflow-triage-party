#!/bin/bash

set -euox pipefail

PRIJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

cd "${PRIJECT_ROOT}" || exit 1

source "_common_variables.sh"

docker build triage-party \
	--tag=triage-party

docker build . \
	--tag="${FULL_IMAGE_NAME}"\
	--file=Dockerfile.prod
