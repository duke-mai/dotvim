#!/usr/bin/env bash
# Open one throwaway file of every filetype this repo has a ftplugin/ for,
# in a single Vim session (so cross-filetype mapping-collision regressions
# would surface too), and fail on any Vim error.
#
# Usage: scripts/ftplugin-open-test.sh
# Exit code: 0 if clean, 1 if any error.

set -uo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 1

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

# One throwaway file per ftplugin/*.vim this repo ships.
echo "x = 1"        > "$TMPDIR/test.py"
echo "echo test"    > "$TMPDIR/test.sh"
echo "console.log()" > "$TMPDIR/test.js"
echo "# test"        > "$TMPDIR/test.md"
echo "<p>test</p>"   > "$TMPDIR/test.html"
echo "test"          > "$TMPDIR/test.tex"
echo "\" test"        > "$TMPDIR/test.vim"
echo "key = 1"        > "$TMPDIR/test.toml"
echo "SELECT 1;"      > "$TMPDIR/test.sql"

SCRIPT_FILE=$(mktemp)
trap 'rm -f "$SCRIPT_FILE"' EXIT
{
  echo "set nomore"
  for f in "$TMPDIR"/test.*; do
    echo "edit $f"
  done
  echo "qa!"
} > "$SCRIPT_FILE"

OUT=$(mktemp)
trap 'rm -f "$OUT"' EXIT

unset DOTVIM DOTFILES
# See startup-smoke-test.sh for why this is needed: `vim -Nu ./vimrc`
# never adds the checkout directory to &packpath/&runtimepath on its
# own, which broke every `packadd <opt-plugin>` call in real CI with
# E919/E185 even when submodules were genuinely checked out correctly.
REPO_ROOT="$(pwd)"
timeout 30 vim -Nu ./vimrc \
  --cmd "set packpath+=$REPO_ROOT" \
  --cmd "set runtimepath+=$REPO_ROOT" \
  -S "$SCRIPT_FILE" < /dev/null > "$OUT" 2>&1

echo "== output =="
cat "$OUT"
echo "== end output =="

errors=$(grep -oE 'E[0-9]+:' "$OUT" | sort -u || true)
if [[ -n "$errors" ]]; then
  echo ""
  echo "FAIL: opening one or more filetypes produced error(s): $errors"
  echo "(see the same submodule-availability caveat as startup-smoke-test.sh)"
  exit 1
fi

echo "OK: all filetypes opened without error."
exit 0
