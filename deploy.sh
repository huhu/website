#!/usr/bin/env bash
# postcss-import, tailwindcss are required.
# npm install postcss-import tailwindcss

set -euo pipefail
cd "$(dirname "$0")"

export ENV="production"
exec bash ./build.sh
