#!/bin/bash

set -euox pipefail

PRIJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

cd "${PRIJECT_ROOT}" || exit 1

source "_common_variables.sh"

docker push "${FULL_IMAGE_NAME}"