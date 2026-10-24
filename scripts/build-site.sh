#!/usr/bin/env bash
# Build the static site into public/.
# Do not set ENV=production: Tailwind's purge then strips the stylesheet
# that https://huhu.io has always served.
set -euo pipefail

cd "$(dirname "$0")/.."

npm ci
./node_modules/.bin/postcss css/index.css -d static/css
zola build

test -s public/index.html
test -s public/css/index.css
grep -q 'meiguo.app' public/index.html
grep -q '^huhu.io$' public/CNAME

echo "Built public/ ($(find public -type f | wc -l) files); footer links to meiguo.app"
