#!/usr/bin/env bash
# Build the static site the way production does: PostCSS, then Zola.
# Tailwind purge runs only when ENV=production (see deploy.sh).
# The stylesheet currently served by https://huhu.io/ is the unpurged output.

set -euo pipefail
cd "$(dirname "$0")"

if [[ ! -x node_modules/.bin/postcss ]]; then
  npm install
fi
export PATH="$PWD/node_modules/.bin:$PATH"

if ! command -v zola >/dev/null 2>&1; then
  version="${ZOLA_VERSION:-0.22.1}"
  dir="$(mktemp -d)"
  curl -fsSL "https://github.com/getzola/zola/releases/download/v${version}/zola-v${version}-x86_64-unknown-linux-gnu.tar.gz" | tar -xz -C "$dir"
  export PATH="$dir:$PATH"
fi

echo 'Compile postcss...'
postcss css/index.css -d static/css

echo 'Zola building...'
zola build
