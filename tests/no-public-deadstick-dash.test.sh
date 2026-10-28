#!/usr/bin/env bash
set -euo pipefail
# Owner requested Dash be restored on 2026-10-27. Preserve its public support surface.
for file in dash/index.html dash/support/index.html dash/privacy/index.html icons/deadstickdash.png apps/deadstickdash.html; do
  test -s "$file" || { echo "Missing Dash asset: $file" >&2; exit 1; }
done
grep -q 'dash/' index.html
grep -q 'dash/support/' support.html
grep -q 'contact@deadstick.net' dash/support/index.html
grep -q 'Screen Recording' dash/privacy/index.html
grep -q 'Sparkle' dash/privacy/index.html
if grep -Eiq 'apps.apple.com|Download on the|Available on the Mac App Store' dash/index.html; then
  echo 'Dash must not imply an unverified store release.' >&2; exit 1
fi
grep -q 'Planned for the Mac App Store' dash/index.html
grep -q '5830 E 2nd St' dash/support/index.html
grep -q 'stdeula' dash/index.html
grep -q 'same or equal protection' dash/privacy/index.html
grep -q 'Retention' dash/privacy/index.html
grep -q 'id="your-choices"' dash/privacy/index.html
grep -q 'Mac App Store edition' dash/privacy/index.html
grep -q 'id="open-source-notices"' dash/index.html
grep -q 'Permission is hereby granted, free of charge' dash/index.html
grep -q 'id="apps-deadstick-dash"' terms.html
grep -q 'Apple, the Apple logo, Mac, macOS, and Apple Silicon are trademarks of Apple Inc.' dash/index.html
grep -q 'Apple, the Apple logo, Mac, macOS, and Apple Silicon are trademarks of Apple Inc.' dash/support/index.html
grep -q 'Apple, the Apple logo, Mac, macOS, and Apple Silicon are trademarks of Apple Inc.' dash/privacy/index.html
echo 'DeadStick Dash product, support, and privacy surfaces verified.'
