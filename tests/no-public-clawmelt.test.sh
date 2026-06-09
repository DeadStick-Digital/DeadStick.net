#!/usr/bin/env bash
set -euo pipefail

patterns=(
  'clawmelt'
  'claw melt'
  'claw-melt'
)

public_files=$(find . apps assets icons \
  -maxdepth 1 \
  -type f \
  \( -name '*.html' -o -name '*.css' -o -name '*.png' -o -name '*.svg' \) \
  -print)

for pattern in "${patterns[@]}"; do
  if printf '%s\n' "$public_files" | grep -inE "$pattern"; then
    printf 'Unexpected public ClawMelt path remains: %s\n' "$pattern" >&2
    exit 1
  fi

  if printf '%s\n' "$public_files" | xargs grep -inE "$pattern"; then
    printf 'Unexpected public ClawMelt reference remains: %s\n' "$pattern" >&2
    exit 1
  fi
done
