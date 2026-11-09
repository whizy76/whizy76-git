#!/usr/bin/env bash
# Copy the chisheu.com version of Browse History Recall into this public repo.
#
# Direction is ONE WAY: chisheu.com (private repo, browse-history/)  ->  this repo.
# Run it from the root of this repo (Git Bash on Windows is fine):
#
#   ./sync-from-site.sh /c/Users/whizy/Desktop/chisheu.com/browse-history
#
# What it does:
#   1. copies index.html and the four library files
#   2. removes the one line that loads the chisheu.com usage counter (this public copy
#      must never report to chisheu.com's stats server)
#   3. refuses to continue if anything chisheu-private slipped in
#
# It does NOT copy og.jpg or preview.jpg (this repo has its own preview.jpg) and never
# commits or pushes. Review `git diff` afterwards, then commit by hand.
set -euo pipefail

SRC="${1:?usage: ./sync-from-site.sh <path to chisheu.com/browse-history>}"
[ -f "$SRC/index.html" ] || { echo "No index.html in $SRC"; exit 1; }

for f in index.html sql-wasm.js sql-wasm.wasm three.min.js OrbitControls.js; do
  cp "$SRC/$f" "./$f"
done

# 2. strip the usage-counter tag
sed -i '/api\.chisheu\.com\/metrics\.js/d' index.html

# 3. sanity checks
if grep -q 'api\.chisheu\.com' index.html; then
  echo "STOP: index.html still mentions api.chisheu.com. Remove it by hand before committing."; exit 1
fi
if grep -Eq 'AIza[0-9A-Za-z_-]{20,}|\bssh-(rsa|ed25519) AAAA|(password|passwd|secret|api[_-]?key|token)[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"']{6,}' index.html; then
  echo "STOP: index.html contains something that looks like a key, token or password. Inspect it."; exit 1
fi

VER=$(grep -o "const VERSION='[^']*'" index.html | head -1 | cut -d"'" -f2)
echo "Synced Browse History Recall v${VER} from $SRC"
echo "Next: review 'git diff --stat', update README/CLAUDE.md notes if needed, commit, push."
