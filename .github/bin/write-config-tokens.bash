#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Keelson contributors (Fred Cooke)
#
# preDockerPrepare hook: writes config tokens into both per-arch docker
# config dirs so the Dockerfile's ${KeelsonScriptsVersion} substitution
# resolves at docker build time. Same dirs are read again at manifest
# packaging time, so Keelson/PackageVersion lands in the manifests too.
#
# Once the build exposes a built-in token for the resolved template
# version this script should read that env var instead of regexing
# KaptainPM.yaml.

set -euo pipefail

: "${VERSION:?VERSION is required (set by the build)}"
: "${OUTPUT_SUB_PATH:?OUTPUT_SUB_PATH is required (set by the build)}"

# Per-arch docker config dirs - same convention as docker-build-dockerfile:
#   ${OUTPUT_SUB_PATH}/docker-linux-${arch}/config
CONFIG_DIRS=(
  "${OUTPUT_SUB_PATH}/docker-linux-amd64/config"
  "${OUTPUT_SUB_PATH}/docker-linux-arm64/config"
)

# Scripts version - pulled from the templates line in KaptainPM.yaml.
KEELSON_SCRIPTS_VERSION=$(grep -oE 'keelson:\[[0-9]+\.[0-9]+\]' KaptainPM.yaml \
  | grep -oE '[0-9]+\.[0-9]+')

echo "Writing keelson-package config tokens"
echo "  VERSION                 = ${VERSION}"
echo "  KEELSON_SCRIPTS_VERSION = ${KEELSON_SCRIPTS_VERSION}"

for config_dir in "${CONFIG_DIRS[@]}"; do
  mkdir -p "${config_dir}/Keelson"
  printf '%s' "${VERSION}" > "${config_dir}/Keelson/PackageVersion"
  printf '%s' "${KEELSON_SCRIPTS_VERSION}" > "${config_dir}/KeelsonScriptsVersion"
  echo "  wrote ${config_dir}/Keelson/PackageVersion        = ${VERSION}"
  echo "  wrote ${config_dir}/KeelsonScriptsVersion          = ${KEELSON_SCRIPTS_VERSION}"
done
