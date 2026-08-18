#!/usr/bin/env bash
# Preview exactly what the scheduled sync workflow (sync-plugins.yml,
# delegating to duc-mt/dotfiles/sync-submodules.yml) would produce if it
# ran right now, WITHOUT committing or pushing anything. That external
# workflow runs `git submodule update --init --recursive --remote`
# (confirmed by reading its actual source, not assumed) then pushes
# straight to master with no review gate. This script runs the identical
# submodule-update command in the current checkout, then runs the same
# validation the push/PR gate runs, so a bad upstream plugin commit is
# visible BEFORE the 3am job would auto-merge it, not after.
#
# Usage: scripts/check-nightly-plugin-compat.sh
# Exit code: 0 if the hypothetical post-sync state is clean, 1 otherwise.
# Never commits or pushes -- this only mutates the local working tree of
# the CI runner it's executed on.

set -uo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 1

echo "== Advancing every submodule to its latest upstream commit (dry run, matches sync-plugins.yml's actual command) =="
git submodule update --init --recursive --remote
update_exit=$?

if [[ "$update_exit" -ne 0 ]]; then
  echo "FAIL: 'git submodule update --remote' itself failed -- at least one"
  echo "submodule URL/branch is broken. This alone would break tomorrow's"
  echo "scheduled sync."
  exit 1
fi

echo ""
echo "== Which submodules would move, and to what =="
git submodule status | while read -r line; do
  echo "  $line"
done

echo ""
echo "== Running startup smoke test against the hypothetical post-sync state =="
if ! bash scripts/startup-smoke-test.sh; then
  echo ""
  echo "FAIL: startup would break if tonight's sync ran as-is."
  exit 1
fi

echo ""
echo "== Running per-filetype open test against the hypothetical post-sync state =="
if ! bash scripts/ftplugin-open-test.sh; then
  echo ""
  echo "FAIL: opening one or more filetypes would break if tonight's sync ran as-is."
  exit 1
fi

echo ""
echo "OK: tonight's scheduled sync would currently produce a working config."
exit 0
