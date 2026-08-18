#!/usr/bin/env bash
# Verify every path declared in .gitmodules has a corresponding directory
# on disk, and every pack/*/{start,opt}/<plugin> directory has a
# corresponding .gitmodules entry. Catches the exact class of drift that
# broke a real patch application during this repo's history: a plugin
# moved between start/ and opt/ in vimrc/pack/plugins.vim without the
# submodule itself being relocated at the git level, producing
# "fatal: No url found for submodule path '...' in .gitmodules".
#
# Usage: scripts/check-gitmodules-consistency.sh
# Exit code: 0 if consistent, 1 if any drift found.

set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

fail=0

echo "== Checking .gitmodules paths exist on disk =="
while IFS= read -r path; do
  if [[ ! -d "$path" ]]; then
    echo "FAIL: .gitmodules declares '$path' but no directory exists on disk"
    fail=1
  fi
done < <(git config -f .gitmodules --get-regexp '\.path$' | awk '{print $2}')

echo "== Checking every pack/*/{start,opt}/<plugin> dir has a .gitmodules entry =="
while IFS= read -r dir; do
  path="${dir#./}"
  if ! git config -f .gitmodules --get-regexp '\.path$' | awk '{print $2}' | grep -qx "$path"; then
    echo "FAIL: '$path' exists on disk but has no .gitmodules entry"
    fail=1
  fi
done < <(find pack -mindepth 3 -maxdepth 3 -type d \( -path '*/start/*' -o -path '*/opt/*' \))

if [[ "$fail" -eq 0 ]]; then
  echo "OK: .gitmodules and pack/ are consistent."
else
  echo ""
  echo "Inconsistency found. If you just moved a plugin between start/ and"
  echo "opt/, remember: editing .gitmodules text alone does not move the"
  echo "actual git submodule pointer. See the git submodule deinit/rm/init"
  echo "sequence documented in this repo's fix history for the correct way"
  echo "to relocate a submodule."
fi

exit "$fail"
