#!/usr/bin/env bash
# Local build. Publishing is scripts/deploy-docs.sh (GitHub Actions on master).
set -euo pipefail
exec "$(dirname "$0")/scripts/build-site.sh"
