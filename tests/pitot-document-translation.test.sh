#!/usr/bin/env bash
set -euo pipefail

require() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! git grep -q "$pattern" -- "$file"; then
    printf 'Missing expected Pitot translation copy: %s\n' "$message" >&2
    exit 1
  fi
}

require 'translate extracted text' \
  index.html \
  'Homepage Pitot card should mention document translation'

require 'Translate extracted document text' \
  apps/pitot.html \
  'Pitot detail page should list document translation'

require 'document translation' \
  apps/pitot.html \
  'Pitot release copy should include document translation'

require 'translations' \
  privacy.html \
  'Privacy policy should include translated document data'

require 'translations' \
  deletion.html \
  'Deletion guidance should include translated document data'

require 'translation' \
  terms.html \
  'Terms should include Pitot translation tooling'
