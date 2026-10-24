# website
Website of Huhu.io

## Development
- npm install
- postcss css/index.css -d static/css -w
- zola serve

Web server is available at http://127.0.0.1:1111

Do not set `ENV=production` when compiling CSS. That turns on Tailwind purge and drops most of the stylesheet the live site uses.

## Deploy

Pushes to `master` run `.github/workflows/deploy.yml`: Zola 0.17.2 builds the site and `scripts/deploy-docs.sh` force-pushes `public/` to branch `now`. GitHub Pages serves `now` at `/` (root). `static/CNAME` sets the custom domain to `huhu.io`.

`huhu.io` is hosted in Cloudflare DNS (`aron.ns.cloudflare.com`, `julio.ns.cloudflare.com`). This repository cannot edit that zone. Replace the records that currently answer with Cloudflare's proxy addresses (`104.21.29.165`, `172.67.149.133`, and the `2606:4700::` AAAA records) — those point the apex at Cloudflare Pages.

Apex (`huhu.io`), DNS only (grey cloud):

| Type | Value |
| --- | --- |
| A | `185.199.108.153` |
| A | `185.199.109.153` |
| A | `185.199.110.153` |
| A | `185.199.111.153` |
| AAAA | `2606:50c0:8000::153` |
| AAAA | `2606:50c0:8001::153` |
| AAAA | `2606:50c0:8002::153` |
| AAAA | `2606:50c0:8003::153` |

`www` (optional): CNAME `www` → `huhu.github.io`.

Remove the Cloudflare Pages custom domain for `huhu.io` before saving the new records, or Pages will put the old origin back. Until this change lands, `https://huhu.io/` stays on Cloudflare Pages. The GitHub Pages copy is `https://huhu.github.io/website/` (it redirects to `huhu.io` once the custom domain is saved).
