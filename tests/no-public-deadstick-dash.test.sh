#!/usr/bin/env bash
set -euo pipefail

# DeadStick Dash was removed from the public website on 2026-08-07 at the
# owner's direction. No public page, card, link, or policy section may
# reference it, and its page and icon files must stay deleted.

if [ -e apps/deadstickdash.html ] || [ -e icons/deadstickdash.png ]; then
  echo 'Retired DeadStick Dash page or icon files must not return.' >&2
  exit 1
fi

if grep -rn -i -e 'deadstick dash' -e 'deadstickdash' --include='*.html' . | grep -v '.archive' | grep -q .; then
  echo 'Retired DeadStick Dash references must not appear on public pages:' >&2
  grep -rn -i -e 'deadstick dash' -e 'deadstickdash' --include='*.html' . | grep -v '.archive' >&2
  exit 1
fi

echo "No public DeadStick Dash references found."
