# keelson-package - Keelson scripts laid into the Keelson base image.
#
# Multi-stage build:
#   * Stage 1 pulls the scripts OCI image published by the keelson project
#     at the version pinned via the templates section of KaptainPM.yaml.
#   * Stage 2 lays those scripts onto the keelson-base-image at the exact
#     patch pinned below. Bump that pin manually when a new patch is wanted.
#
# ${KeelsonScriptsVersion} is the built-in token the build derives from the
# templates entry in KaptainPM.yaml so the FROM here is locked to the same
# release as the manifests/contract content downstream consumers receive.
# That keeps the Dockerfile and the manifests bundled into the keelson-package
# release in lockstep - no drift between what runs in the pod and what the
# install manifests describe.

FROM ghcr.io/keelson-pro/keelson/keelson:${KeelsonScriptsVersion} AS KEELSON_SCRIPTS
# Always use the most specific tag possible

FROM ghcr.io/keelson-pro/keelson/keelson-base-image:1.32.5
# Always use the most specific tag possible

# Lay the scripts on the path the base image already exports as ${PATH}
COPY --from=KEELSON_SCRIPTS / /keelson/bin

# Drop root - KEELSON_USER_ID is exported by the base image
USER ${KEELSON_USER_ID}
