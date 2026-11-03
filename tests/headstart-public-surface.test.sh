#!/usr/bin/env bash
set -euo pipefail

for file in headstart/index.html headstart/headstart.css headstart/headstart.plg headstart/install.sh headstart/support/index.html headstart/privacy/index.html icons/headstart.png apps/headstart.html; do
  test -s "$file" || { echo "Missing HeadStart asset: $file" >&2; exit 1; }
done

grep -q 'headstart/' index.html
grep -q 'headstart/support/' support.html
grep -q 'https://www.deadstick.net/headstart/headstart.plg' headstart/index.html
grep -q 'https://www.deadstick.net/headstart/install.sh' headstart/index.html
grep -q 'Engineered for media servers.' headstart/index.html
! grep -q '100+ TB' headstart/index.html
! grep -q 'mode=ro' headstart/index.html headstart/support/index.html headstart/privacy/index.html
! grep -q '\.pchunk' headstart/index.html headstart/support/index.html headstart/privacy/index.html
! grep -q 'HDSTART1' headstart/index.html headstart/support/index.html headstart/privacy/index.html
! grep -q 'CRC32C' headstart/index.html headstart/support/index.html headstart/privacy/index.html
grep -q 'BillingBird' headstart/index.html
grep -q 'CarrierPigeonVPN' headstart/index.html
grep -q 'DeadStick Dash' headstart/index.html
grep -q 'Drive Vault' headstart/index.html
grep -q 'Document Vault' headstart/index.html
grep -q 'DeadStick Utilities' headstart/index.html
grep -q 'contact@deadstick.net' headstart/support/index.html
grep -q '5830 E 2nd St' headstart/privacy/index.html

# WP5 checks:
# 1. headstart.plg must have a <SHA256> element
grep -q '<SHA256>' headstart/headstart.plg || { echo "headstart.plg missing <SHA256> element" >&2; exit 1; }

# 2. install.sh must contain no "|| true" on curl lines
if grep -E 'curl .*(\|\| *true)' headstart/install.sh; then
  echo "install.sh contains '|| true' on a curl line" >&2
  exit 1
fi

# 3. bash -n syntax validation on install.sh and all <INLINE> scripts in headstart.plg
bash -n headstart/install.sh

INLINE_COUNT="$(xmllint --noent --xpath 'count(//FILE/INLINE)' headstart/headstart.plg)"
for ((i = 1; i <= INLINE_COUNT; i++)); do
  tmp_inline="$(mktemp)"
  xmllint --noent --xpath "string((//FILE/INLINE)[$i])" headstart/headstart.plg > "$tmp_inline"
  bash -n "$tmp_inline"
  if command -v shellcheck >/dev/null 2>&1; then
    shellcheck -s bash "$tmp_inline"
  fi
  rm -f "$tmp_inline"
done

if command -v shellcheck >/dev/null 2>&1; then
  shellcheck -s bash headstart/install.sh
fi

# 4. Verify every local href/src and #fragment anchor across HeadStart HTML pages
python3 - <<'PY'
import pathlib, re, sys

root = pathlib.Path(".")
pages = [
    root / "headstart/index.html",
    root / "headstart/support/index.html",
    root / "headstart/privacy/index.html",
    root / "apps/headstart.html",
]

attr_re = re.compile(r'''(?:href|src)=["']([^"']+)["']''')

for page in pages:
    html = page.read_text(encoding="utf-8")
    for raw in attr_re.findall(html):
        if raw.startswith(("http://", "https://", "mailto:", "tel:", "javascript:", "data:")):
            continue
        path_part, _, frag = raw.partition("#")
        path_part = path_part.split("?", 1)[0]
        if not path_part:
            target_file = page
        elif path_part.startswith("/"):
            target_file = root / path_part.lstrip("/")
        else:
            target_file = (page.parent / path_part).resolve()
        if target_file.is_dir():
            target_file = target_file / "index.html"
        if not target_file.is_file():
            print(f"Broken local link in {page}: {raw} -> {target_file} not found", file=sys.stderr)
            sys.exit(1)
        if frag:
            target_html = target_file.read_text(encoding="utf-8")
            id_pat = re.compile(rf'''id=["']{re.escape(frag)}["']''')
            if not id_pat.search(target_html):
                print(f"Missing #{frag} anchor in {target_file} (referenced from {page})", file=sys.stderr)
                sys.exit(1)
PY

echo 'HeadStart product, plugin download, ecosystem cross-sell, support, and privacy surfaces verified.'
