#!/usr/bin/env bash
# Re-assert two specific, hand-found-and-fixed security issues from this
# repo's history haven't silently regressed:
#
# 1. No automatic privileged (sudo) command in an autocommand. An earlier
#    version of vimrc had `au BufWinLeave $DOTFILES/bash/crontab :!sudo cp
#    % /etc/crontab` -- an unprompted privileged file copy triggered just
#    by switching windows away from that buffer. Removed; this check
#    makes sure nothing equivalent comes back.
#
# 2. The GPGSafety autocmd (disables undofile/backup/swapfile/clipboard-
#    sync for *.gpg/*.asc/*.pgp buffers) is still present. Without it,
#    editing an encrypted file could write DECRYPTED plaintext to
#    $DOTVIM/.tmp/undodir or $DOTVIM/.tmp/backupdir on disk, or leak
#    yanked plaintext to the system clipboard.
#
# Usage: scripts/check-security-regressions.sh
# Exit code: 0 if both protections are intact, 1 otherwise.

set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

fail=0

echo "== Checking for automatic sudo commands in autocommands =="
# Matches an autocmd line (au/autocmd) that also contains sudo, anywhere
# in vimrc or pack/plugins.vim. A manually-triggered mapping that
# contains sudo (e.g. this repo's <S-F6> dos2unix-with-sudo mapping,
# which requires an explicit keypress and shows a real sudo prompt) is
# NOT the same risk class and is intentionally not flagged here -- only
# autocmd-triggered, unprompted sudo is checked.
hits=$(grep -nE '^\s*(au|autocmd)\s.*sudo' vimrc pack/plugins.vim 2>/dev/null || true)
if [[ -n "$hits" ]]; then
  echo "FAIL: found an autocommand invoking sudo -- this is the exact"
  echo "regression class of the removed 'sudo cp % /etc/crontab' issue:"
  echo "$hits"
  fail=1
else
  echo "OK: no autocommand invokes sudo."
fi

echo ""
echo "== Checking the GPGSafety autocmd is still present and intact =="
if ! grep -q '^augroup GPGSafety$' vimrc; then
  echo "FAIL: the GPGSafety augroup is missing entirely from vimrc."
  fail=1
elif ! grep -q 'noundofile nobackup noswapfile' vimrc; then
  echo "FAIL: GPGSafety augroup exists but no longer sets"
  echo "noundofile/nobackup/noswapfile for *.gpg/*.asc/*.pgp buffers."
  fail=1
else
  echo "OK: GPGSafety protections are intact."
fi

if [[ "$fail" -eq 0 ]]; then
  echo ""
  echo "OK: both hand-fixed security issues remain fixed."
fi

exit "$fail"
