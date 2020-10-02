#!/bin/bash

set -euo pipefail
STREAM=$1
shift

GCS_LOG_URL=gs://airflow-triage-party-ci-logs/${STREAM}/${GITHUB_SHA}.txt

echo "Logs are not available on Gitthub Action for security reasons."
echo "If you are authorized to access them, run:"
echo
echo "   gsutil cat ${GCS_LOG_URL}"
echo

bash -c "${*}" 2>&1 | gsutil -h "Content-Type: text/plain" cp - "${GCS_LOG_URL}"
