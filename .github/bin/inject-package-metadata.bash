#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Keelson contributors (Fred Cooke)
#
# prePackagePrepare hook: injects keelson-package lineage annotations
# into every staged manifest doc. Token writing is handled separately by
# write-config-tokens.bash at preDockerPrepare time.
#
# Runs here (not in KaptainPM.yaml) because the manifests arrive via
# templates - we own the resulting bundle so we add our own values on
# top of what the template provides.

set -euo pipefail

: "${VERSION:?VERSION is required (set by the build)}"
: "${OUTPUT_SUB_PATH:?OUTPUT_SUB_PATH is required (set by the build)}"

STAGED_MANIFESTS_DIR="${OUTPUT_SUB_PATH}/manifests/additional-manifests"

# Scripts version - pulled from the templates line in KaptainPM.yaml.
KEELSON_SCRIPTS_VERSION=$(grep -oE 'keelson:\[[0-9]+\.[0-9]+\]' KaptainPM.yaml \
  | grep -oE '[0-9]+\.[0-9]+')

# Base image version - pulled from the Dockerfile FROM line.
KEELSON_BASE_IMAGE_VERSION=$(grep -oE 'keelson-base-image:[0-9]+\.[0-9]+\.[0-9]+' \
  src/docker/Dockerfile \
  | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')

BUILT_AT=$(date -u +%Y-%m-%dT%H:%M:%SZ)

echo "Injecting keelson-package metadata"
echo "  VERSION                    = ${VERSION}"
echo "  KEELSON_SCRIPTS_VERSION    = ${KEELSON_SCRIPTS_VERSION}"
echo "  KEELSON_BASE_IMAGE_VERSION = ${KEELSON_BASE_IMAGE_VERSION}"
echo "  BUILT_AT                   = ${BUILT_AT}"

if [[ ! -d "${STAGED_MANIFESTS_DIR}" ]]; then
  echo "Staged manifests dir not found: ${STAGED_MANIFESTS_DIR}" >&2
  exit 1
fi

while IFS= read -r -d '' manifest_file; do
  echo "  annotating ${manifest_file}"
  yq eval -i \
    ".metadata.annotations.\"keelson.pro/keelson-package-version\" = \"${VERSION}\" |
     .metadata.annotations.\"keelson.pro/keelson-package-scripts-version\" = \"${KEELSON_SCRIPTS_VERSION}\" |
     .metadata.annotations.\"keelson.pro/keelson-package-base-image-version\" = \"${KEELSON_BASE_IMAGE_VERSION}\" |
     .metadata.annotations.\"keelson.pro/keelson-package-built-at\" = \"${BUILT_AT}\"" \
    "${manifest_file}"
done < <(find "${STAGED_MANIFESTS_DIR}" -type f -name '*.yaml' -print0)
