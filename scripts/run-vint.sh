#!/usr/bin/env bash
# Run vint (Vimscript linter) at error-severity across the files it can
# actually parse, and separately report vimrc's known parser-limitation
# finding as non-blocking. See .vintrc.yaml for the full rationale.
#
# PREREQUISITE if running locally: `pip install "setuptools<81" vim-vint`,
# not just `pip install vim-vint`. vim-vint (last released version 0.3.21)
# imports the deprecated `pkg_resources` module; setuptools 81+ dropped it
# entirely, which breaks vint outright with "ModuleNotFoundError: No
# module named 'pkg_resources'" on any environment where pip installs the
# newest setuptools by default. This bit CI directly once already (see
# validate.yml's vimscript-lint job for the full incident notes). This is
# a time-bounded workaround: pkg_resources itself is slated for full
# removal from Python packaging as early as 2025-11-30, at which point
# even `setuptools<81` won't help unless vim-vint's upstream has fixed
# this by then.
#
# Usage: scripts/run-vint.sh
# Exit code: 0 if the blocking set is clean, 1 if it finds a real error.
# vimrc's parse limitation is reported but never affects the exit code.

set -uo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 1

echo "== vint (error severity) on files vint can fully parse =="
BLOCKING_FILES="pack/plugins.vim pack/lf.vim ftplugin/*.vim wordlist/plugins/*.vim"
# shellcheck disable=SC2086
vint -e $BLOCKING_FILES
blocking_exit=$?

echo ""
echo "== vint on vimrc (informational only -- known parser limitation) =="
echo "vimrc uses a 0o700-style octal literal that vint's parser doesn't"
echo "support; this aborts parsing for the whole file. Reported here for"
echo "visibility, not treated as a failure. See .vintrc.yaml."
vint -e vimrc || true

if [[ "$blocking_exit" -ne 0 ]]; then
  echo ""
  echo "FAIL: vint found error-severity issues in the blocking file set."
  exit 1
fi

echo ""
echo "OK: no error-severity vint findings in the blocking file set."
exit 0
