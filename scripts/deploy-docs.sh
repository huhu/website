#!/usr/bin/env bash
# Publish public/ to the `now` branch and serve it with GitHub Pages.
# Same shape as the other huhu sites: build the static site, force-push
# branch `now`, custom domain on GitHub Pages (root of that branch).
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ -z "${GITHUB_TOKEN:-}" || -z "${GITHUB_REPOSITORY:-}" ]]; then
  echo "GITHUB_TOKEN and GITHUB_REPOSITORY are required (set by Actions)." >&2
  exit 1
fi

if [[ ! -s public/index.html ]]; then
  ./scripts/build-site.sh
fi

BRANCH=now
REMOTE="https://github.com/${GITHUB_REPOSITORY}.git"
API="https://api.github.com/repos/${GITHUB_REPOSITORY}/pages"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

cp -a public/. "$WORK/"
rm -rf "$WORK/.git"
printf '%s\n' 'huhu.io' > "$WORK/CNAME"
: > "$WORK/.nojekyll"

grep -q 'meiguo.app' "$WORK/index.html"
grep -q '^huhu.io$' "$WORK/CNAME"

git -C "$WORK" init -b "$BRANCH"
git -C "$WORK" add -A
git -C "$WORK" \
  -c user.name='github-actions[bot]' \
  -c user.email='41898282+github-actions[bot]@users.noreply.github.com' \
  commit -m "Deploy huhu.io"

export GIT_TERMINAL_PROMPT=0
git_auth=(-c "http.extraheader=AUTHORIZATION: bearer ${GITHUB_TOKEN}")

# Pushes must run inside the orphan site repo, not the source checkout.
site_git() {
  git -C "$WORK" "${git_auth[@]}" "$@"
}

branch_missing() {
  local rc
  set +e
  git "${git_auth[@]}" ls-remote --exit-code --heads "$REMOTE" "$BRANCH" >/dev/null
  rc=$?
  set -e
  if [[ "$rc" -eq 0 ]]; then
    return 1
  fi
  if [[ "$rc" -eq 2 ]]; then
    return 0
  fi
  echo "Could not read refs/heads/${BRANCH} (git ls-remote exit ${rc})." >&2
  exit "$rc"
}

# Pages rejects a source branch that does not exist yet.
pre_pushed=0
if branch_missing; then
  echo "Creating ${BRANCH} so GitHub Pages can publish it."
  site_git push "$REMOTE" "HEAD:${BRANCH}"
  pre_pushed=1
fi

gh_api() {
  curl -sS -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    -H "Content-Type: application/json" \
    "$@"
}

code="$(gh_api -o /tmp/pages.json -w '%{http_code}' "$API")"
if [[ "$code" == "404" ]]; then
  code="$(gh_api -o /tmp/pages.json -w '%{http_code}' -X POST "$API" \
    -d '{"build_type":"legacy","source":{"branch":"now","path":"/"}}')"
  if [[ "$code" != "201" && "$code" != "409" ]]; then
    echo "Creating the GitHub Pages site failed (HTTP ${code})." >&2
    cat /tmp/pages.json >&2
    echo >&2
    echo "Folyd: Settings → Pages → Deploy from a branch → Branch: now, folder: / (root), custom domain huhu.io." >&2
    exit 1
  fi
elif [[ "$code" != "200" ]]; then
  echo "Reading the GitHub Pages site failed (HTTP ${code})." >&2
  cat /tmp/pages.json >&2
  exit 1
fi

# public=true keeps the site on the internet when the repo itself is private.
payload='{"cname":"huhu.io","public":true,"build_type":"legacy","source":{"branch":"now","path":"/"}}'
code="$(gh_api -o /tmp/pages-put.json -w '%{http_code}' -X PUT "$API" -d "$payload")"
if [[ "$code" == "422" ]] && grep -q 'public' /tmp/pages-put.json; then
  payload='{"cname":"huhu.io","build_type":"legacy","source":{"branch":"now","path":"/"}}'
  code="$(gh_api -o /tmp/pages-put.json -w '%{http_code}' -X PUT "$API" -d "$payload")"
fi
if [[ "$code" != "204" && "$code" != "200" ]]; then
  echo "Updating GitHub Pages failed (HTTP ${code})." >&2
  cat /tmp/pages-put.json >&2
  echo >&2
  echo "Folyd: Settings → Pages → Deploy from a branch → Branch: now, folder: / (root), custom domain huhu.io." >&2
  exit 1
fi

# The branch must move after Pages is pointed at it, or the first publish
# never builds (the create-branch push happened too early).
if [[ "$pre_pushed" -eq 1 ]]; then
  git -C "$WORK" \
    -c user.name='github-actions[bot]' \
    -c user.email='41898282+github-actions[bot]@users.noreply.github.com' \
    commit --allow-empty -m "Trigger GitHub Pages build"
fi

site_git push --force "$REMOTE" "HEAD:${BRANCH}"

echo "Published ${BRANCH}."
gh_api "$API" | jq '{html_url,cname,public,build_type,source,status,https_enforced}'
