#!/bin/bash

if [[ -z "$PROJECT_ID" ]]; then
	if [[ -z "$GCLOUD_PROJECT_ID" ]]; then
		PROJECT_ID="${GCLOUD_PROJECT_ID}"
	else
		PROJECT_ID="$(gcloud config get-value "core/project")"
	fi
fi

readonly PROJECT_ID

CONTAINER_REGISTRY_URL=${CONTAINER_REGISTRY_URL:="gcr.io/${PROJECT_ID}"}
readonly CONTAINER_REGISTRY_URL

IMAGE_NAME=${IMAGE_NAME:="${CONTAINER_REGISTRY_URL}/triage-party"}
readonly IMAGE_NAME

IMAGE_TAG=${IMAGE_TAG:="latest"}
readonly IMAGE_TAG

FULL_IMAGE_NAME=${FULL_IMAGE_NAME:="${IMAGE_NAME}:${IMAGE_TAG}"}
readonly FULL_IMAGE_NAME
