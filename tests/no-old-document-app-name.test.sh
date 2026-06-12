#!/usr/bin/env bash
set -euo pipefail

old_product="$(printf '%s%s' 'Voyage' 'Vault')"
old_slug="$(printf '%s%s' 'pi' 'tot')"

public_files=$(find . \
  -path './.git' -prune -o \
  -type f \
  -print)

for pattern in "$old_product" "$old_slug"; do
  if printf '%s\n' "$public_files" | grep -iF "$pattern"; then
    printf 'Unexpected retired document-app path remains.\n' >&2
    exit 1
  fi

  if printf '%s\n' "$public_files" | xargs grep -IinF "$pattern"; then
    printf 'Unexpected retired document-app reference remains.\n' >&2
    exit 1
  fi
done
