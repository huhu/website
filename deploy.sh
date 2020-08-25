#!/usr/bin/env bash

set -e

export ENV="production"

echo 'Compile postcss...'
postcss css/index.css -d static/css

echo 'Zola building...'
zola build

echo 'Vercel deploying...'
vercel --prod