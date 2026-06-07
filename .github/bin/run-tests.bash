#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Keelson contributors (Fred Cooke)
#
# preTaggingTests hook. Lints the hook scripts in .github/bin via shellcheck.
# Runs from any CWD: resolves the repo root from this script's location.
# Linting runs locally (small enough not to warrant a container).

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

printf '== shellcheck (.github/bin/*.bash) ==\n'
if ! command -v shellcheck >/dev/null 2>&1; then
    printf 'shellcheck not found on PATH - install it locally (brew install shellcheck / apt install shellcheck)\n' >&2
    exit 1
fi
shopt -s nullglob
SCRIPTS=(.github/bin/*.bash)
if [[ ${#SCRIPTS[@]} -eq 0 ]]; then
    printf 'no .bash scripts found under .github/bin\n' >&2
    exit 1
fi
shellcheck --shell=bash "${SCRIPTS[@]}"
