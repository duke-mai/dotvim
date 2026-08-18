#!/usr/bin/env bash
# Source vimrc headlessly and fail if Vim reports any E### error, or exits
# non-zero. This is the single highest-leverage check for this repo: most
# bugs found by hand across this repo's fix history (the spellcapcheck
# bug, the unset-$DOTVIM/$DOTFILES failure mode, autocmd duplication on
# reload) would all have been caught immediately by this one test.
#
# Usage: scripts/startup-smoke-test.sh
# Exit code: 0 if clean, 1 if Vim errored or reported any E### message.

set -uo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 1

OUT=$(mktemp)
trap 'rm -f "$OUT"' EXIT

# Deliberately do NOT set $DOTVIM/$DOTFILES here -- this is the exact
# scenario (a bare `vim -u vimrc` invocation) that originally broke this
# repo's startup with 4x E484 errors before the environment guard was
# added. Leaving them unset keeps this test honest about that regression
# risk rather than masking it.
unset DOTVIM DOTFILES

timeout 30 vim -Nu ./vimrc -c 'set nomore' -c 'qa!' < /dev/null > "$OUT" 2>&1
vim_exit=$?

echo "== vim exit code: $vim_exit =="
echo "== output =="
cat "$OUT"
echo "== end output =="

errors=$(grep -oE 'E[0-9]+:' "$OUT" | sort -u || true)

if [[ -n "$errors" ]]; then
  echo ""
  echo "FAIL: Vim reported error(s): $errors"
  echo ""
  echo "NOTE: this repo's CI environment does not have the real plugin"
  echo "content for opt/-lazy-loaded plugins available in some contexts"
  echo "(e.g. a shallow checkout without --recursive submodules). If you"
  echo "see E919 (packadd target not found) or E185 (colorscheme not"
  echo "found) specifically, first confirm the workflow step checked out"
  echo "submodules recursively before treating this as a real regression."
  exit 1
fi

echo "OK: no Vim errors detected."
exit 0
