# Keelson Package

The deployable form of [Keelson](https://github.com/keelson-pro/keelson). The
Keelson scripts laid into the Keelson base image, bundled with matching template
manifests and contract+defaults so consumers get a working install with no config.


## Contents

- **`src/docker/Dockerfile`** - multi-stage multi-arch build, inspect the file for more detail
- **`KaptainPM.yaml`** - declares the build kind, the templates pulled from the keelson project, the metadata-injection hook, and the 5-part release versioning scheme.
- **`.github/bin/inject-package-metadata.bash`** - prePackagePrepare hook. Adds keelson-package lineage annotations to the template manifests and writes the `Keelson/PackageVersion` and `KeelsonScriptsVersion` tokens so the bundled manifests stay locked to the scripts release we packaged.


## Release Versioning

Five parts: `X.X.Y.Y.Z`.

- `X.X` is the keelson template version (pulled from the templates line in `KaptainPM.yaml`).
- `Y.Y` is the first two parts of the keelson-base-image version (pulled from the Dockerfile FROM line).
- `Z` is the auto-incrementing patch, usually 1 since any change to the dependencies changes the base

Bumping either the template version or the base image bumps the corresponding part. Backport branches `main-1.35`, `main-1.34` etc. follow the same scheme against their own base image line.
