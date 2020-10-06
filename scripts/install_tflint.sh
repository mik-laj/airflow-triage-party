#!/usr/bin/env bash

TFLINT_VERSION="v0.20.1"
TFLINT_BASE_URL="https://github.com/terraform-linters/tflint/releases/download"
TFLINT_ZIP="tflint_$(uname | tr '[:upper:]' '[:lower:]')_amd64.zip"
echo "Downloading from ${TFLINT_BASE_URL}/${TFLINT_VERSION}/${TFLINT_ZIP}"
curl -Lo /tmp/tflint.zip "${TFLINT_BASE_URL}/${TFLINT_VERSION}/${TFLINT_ZIP}"
sudo unzip /tmp/tflint.zip -d /bin
