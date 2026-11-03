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
grep -q 'BillingBird' headstart/index.html
grep -q 'CarrierPigeonVPN' headstart/index.html
grep -q 'DeadStick Dash' headstart/index.html
grep -q 'Drive Vault' headstart/index.html
grep -q 'Document Vault' headstart/index.html
grep -q 'DeadStick Utilities' headstart/index.html
grep -q 'contact@deadstick.net' headstart/support/index.html
grep -q '5830 E 2nd St' headstart/privacy/index.html
echo 'HeadStart product, plugin download, ecosystem cross-sell, support, and privacy surfaces verified.'
