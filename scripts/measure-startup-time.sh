#!/usr/bin/env bash
# Measure Vim startup time across N runs and print the median in
# milliseconds. Used by startup-benchmark.yml to track regressions in the
# lazy-loading work done across this repo's fix history (moving
# awesome-vim-colorschemes, colorizer, mundo, floaterm, and 5 language-
# tool plugins from start/ to opt/, deferring the 19KB wordlist to first
# InsertEnter, etc.) -- none of that work has any regression protection
# without this.
#
# Usage: scripts/measure-startup-time.sh [N runs, default 5]
# Prints: a single number (median milliseconds) to stdout, nothing else.
# All diagnostic output goes to stderr so this composes cleanly in CI
# (e.g. `time=$(scripts/measure-startup-time.sh)`).

set -uo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 1

runs="${1:-5}"
times=()

unset DOTVIM DOTFILES

for i in $(seq 1 "$runs"); do
  log=$(mktemp)
  timeout 30 vim -Nu ./vimrc --startuptime "$log" -c 'set nomore' -c 'qa!' < /dev/null > /dev/null 2>&1
  # The last line of a --startuptime log is the total elapsed time in ms,
  # as the first whitespace-separated field.
  ms=$(tail -1 "$log" | awk '{print $1}')
  rm -f "$log"
  echo "run $i: ${ms}ms" >&2
  times+=("$ms")
done

# Median via sort + middle element (odd count assumed for the default of
# 5; for an even count this takes the lower-middle, which is fine for a
# rough regression signal).
mapfile -t sorted < <(printf '%s\n' "${times[@]}" | sort -n)
median_index=$(( (${#sorted[@]} - 1) / 2 ))
median="${sorted[$median_index]}"

echo "median: ${median}ms" >&2
echo "$median"
