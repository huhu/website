#!/usr/bin/env bash
# postcss-import, tailwindcss are required.
# npm install postcss-import tailwindcss

set -e

export ENV="production"

npm install

echo 'Compile postcss...'
postcss css/index.css -d static/css

echo 'Zola building...'
zola build