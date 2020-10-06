#!/bin/bash

set -euox pipefail

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"
readonly ROOT_DIR

echo "${ROOT_DIR}"
cd "${ROOT_DIR}"

GITHUB_TOKEN=$(grep oauth_token ~/.config/gh/config.yml| cut -d ":" -f 2 | sed "s/ //g")
export GITHUB_TOKEN

docker run \
    --rm \
    -ti \
    -e GITHUB_TOKEN \
    -e CONFIG_PATH=/config/config.yaml \
    -v "$PWD/config.yaml:/config/config.yaml" \
    -e PERSIST_PATH=/app/pcache/pcache \
    -v "$PWD/pcache:/app/pcache" \
    -e PORT=8080 -p 8080:8080 \
    triage-party \
    /app/main \
        --name "Airflow" \
        --min-refresh=30s \
        --max-refresh=8m \
        --site=/app/site \
        --3p=/app/third_party \
        -skip_headers
