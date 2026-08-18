#!/usr/bin/env bash
# Lint ftplugin/*.vim for two specific, previously-real bug classes found
# by hand in this repo's history:
#
# 1. Non-buffer-local mappings. ftplugin files re-run once per buffer
#    opened, not once per session, so a bare `nn`/`nnoremap`/`vn`/etc.
#    (missing <buffer>) becomes a GLOBAL mapping the moment that filetype
#    is opened once -- silently overriding the same key for every other
#    filetype for the rest of the session. This exact bug caused <F5> to
#    run the wrong interpreter depending on which filetype was opened
#    last.
#
# 2. Global `set` instead of `setlocal`/`setl` for filetype-specific
#    options. Same story: a global `set` in an ftplugin file leaks that
#    setting into every other buffer, not just the current filetype's.
#
# Usage: scripts/check-ftplugin-hygiene.sh
# Exit code: 0 if clean, 1 if any violation found.

set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

fail=0

echo "== Checking for non-buffer-local mappings in ftplugin/*.vim =="
for f in ftplugin/*.vim; do
  # Match mapping commands at the start of a line, excluding ones that
  # already contain <buffer>. Covers the normal/visual/insert/etc.
  # short-forms and their *noremap long-forms.
  hits=$(grep -nE '^[[:space:]]*(nn|nnoremap|vn|vnoremap|xn|xnoremap|ino|inoremap|cn|cnoremap|map|noremap)[[:space:]]' "$f" \
    | grep -v '<buffer>' || true)
  if [[ -n "$hits" ]]; then
    echo "FAIL: $f has non-buffer-local mapping(s):"
    echo "    ${hits//$'\n'/$'\n'    }"
    fail=1
  fi
done

echo "== Checking for global 'set' (should be 'setl'/'setlocal') in ftplugin/*.vim =="
for f in ftplugin/*.vim; do
  hits=$(grep -nE '^[[:space:]]*(set|se)[[:space:]]' "$f" || true)
  if [[ -n "$hits" ]]; then
    echo "FAIL: $f has global 'set' (use 'setl'/'setlocal' instead):"
    echo "    ${hits//$'\n'/$'\n'    }"
    fail=1
  fi
done

echo "== Checking for the standard re-entry guard (b:did_ftplugin or b:did_indent) =="
for f in ftplugin/*.vim; do
  if ! head -25 "$f" | grep -qE 'b:did_ftplugin|b:did_indent'; then
    echo "FAIL: $f is missing the standard re-entry guard"
    fail=1
  fi
done

if [[ "$fail" -eq 0 ]]; then
  echo "OK: all ftplugin files are buffer-scoped, use setl consistently, and have a re-entry guard."
fi

exit "$fail"
