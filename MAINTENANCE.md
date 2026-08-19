# dotvim — Maintenance Guide

> How to safely add plugins, add filetypes, update the config, and troubleshoot when something breaks. Written from this repo's actual fix history — every gotcha in here is something that really happened, not a hypothetical.

---

## 1 · Mental Model — Read This First

Three facts explain almost every mistake that's possible in this repo:

1. **Plugins are git submodules, tracked in two places that must agree.** `.gitmodules` declares the URL and path; the actual directory must exist at that exact path under `pack/`. **Editing `.gitmodules` text does not move a submodule.** This is the single most common way this repo breaks — see §3.
2. **`ftplugin/*.vim` files run once per buffer opened, not once per session.** Any mapping or `set` in one of these files that isn't scoped (`<buffer>` for mappings, `setl`/`setlocal` for options) leaks into every other buffer for the rest of the session. See §4.
3. **CI validates on push/PR, but the scheduled plugin sync bypasses it entirely.** `sync-plugins.yml` delegates to an external workflow that pushes straight to `master` with no review gate. `nightly-plugin-compat.yml` and `post-sync-validate.yml` exist specifically to catch what that gap misses — see §6.

If you only remember one thing: **run `bash scripts/startup-smoke-test.sh` after any change, before you commit.** It's the same check CI runs, and it catches the majority of mistakes in about a second.

---

## 2 · Repository Map

```
vimrc                       Main entry point. Sourced first, sources everything else.
pack/plugins.vim             Per-plugin config (g:variables, plugin-specific autocmds).
pack/lf.vim                  The `LF` file-manager integration command.

pack/<group>/start/<plugin>/ Eager-loaded plugins (loaded on every Vim startup).
pack/<group>/opt/<plugin>/   Lazy-loaded plugins (loaded via `packadd` on demand).
  groups: api, colours, file-system, git, plugins, syntax, writing

ftplugin/<filetype>.vim      Per-filetype settings/mappings. Runs once PER BUFFER.
ftdetect/<name>.vim          Extra filetype-detection rules beyond Vim's defaults.

wordlist/abbreviation/       iabbrev definitions (typo autocorrect).
wordlist/plugins/            :Americanize / :Britishise bulk-substitution commands.
wordlist/spellfile/          Custom spellcheck word additions.

template/                    Boilerplate inserted into new files by filetype.

.gitmodules                  Submodule URL + path declarations. Must match pack/ exactly.
.github/workflows/           CI. See §6.
.github/dependabot.yml       Tracks submodule + Action version updates.
.vintrc.yaml                 Vimscript linter config.
scripts/                     Standalone checks — the same ones CI runs. Run locally anytime.
```

**Load order on startup:** `vimrc` → environment guards → `pack/plugins.vim` + `pack/lf.vim` (via a safe-source helper that warns instead of erroring if either is missing) → wordlist (deferred to first `InsertEnter`) → the rest of `vimrc` (options, mappings, colourscheme, autocommands). `ftplugin/*.vim` files are sourced by Vim's own filetype mechanism whenever a matching buffer opens — not part of the linear vimrc load order at all.

---

## 3 · How to Add a New Plugin

### 3.1 Adding a plugin (the whole process)

```bash
# 1. Decide start/ (always-on) or opt/ (loaded on demand) and which group.
#    Default to opt/ unless you genuinely need it on every single startup —
#    see §3.3 for why this matters.

# 2. Add the submodule at the exact final path you want:
git submodule add https://github.com/author/plugin.git pack/<group>/opt/<plugin>

# 3. If opt/, add a load trigger (see §3.3). If start/, nothing else needed.

# 4. Add any plugin config to pack/plugins.vim, following the existing
#    " Name {{{ ... " }}} fold-marker section pattern.

# 5. Verify before committing:
bash scripts/check-gitmodules-consistency.sh   # confirms .gitmodules matches disk
bash scripts/startup-smoke-test.sh             # confirms nothing broke

# 6. Commit and push. validate.yml will run the same two checks on the PR.
```

### 3.2 Moving a plugin between `start/` and `opt/` (the dangerous one)

**This is the operation that has actually broken this repo before.** The exact failure:

```
fatal: No url found for submodule path 'pack/colours/start/awesome-vim-colorschemes' in .gitmodules
```

**Why it happens:** a submodule's location is tracked in two independent places — the git *index* (a special tree entry pointing at a commit SHA) and the `.gitmodules` *text file*. If you edit `.gitmodules` to point at a new path and physically `mv` the directory, but the old path's index entry is never removed, git ends up with an index entry for a path that no longer has a matching `.gitmodules` block. Any `git submodule` command then fails on that specific submodule.

**The correct sequence:**

```bash
OLD=pack/colours/start/awesome-vim-colorschemes
NEW=pack/colours/opt/awesome-vim-colorschemes

git submodule deinit -f "$OLD"
git rm -f "$OLD"
rm -rf ".git/modules/$OLD"

# Now edit .gitmodules: change the path= and the [submodule "..."] name to $NEW.
# Then re-add cleanly:
git submodule add <url> "$NEW"
```

**After any such move, always run:**
```bash
bash scripts/check-gitmodules-consistency.sh
```
This is exactly the check that would have caught the failure above before it ever reached a real machine — run it locally, not just in CI, whenever you touch `.gitmodules` or move anything under `pack/`.

**A second, distinct failure mode from the same root operation — this one has also happened for real:** `git submodule sync && git submodule update --init --recursive` does **not** create a new gitlink for a path that never had one committed. Those two commands only act on submodules that *already* have a commit-reference entry in the git tree — `sync` updates the remote URL for an already-initialized submodule, and `update --init` initializes a submodule that's already been `git submodule add`-ed and committed at that exact path. If a plugin's *new* `opt/` path was only ever declared in `.gitmodules` text (e.g. from applying a patch that changed the text but never ran `git submodule add` for real), running `sync && update --init --recursive` will silently do **nothing** for that path — no error, no directory, nothing. `.gitmodules` will say the plugin lives there; a fresh clone will have an empty hole where it should be.

The symptom looks identical to a normal missing-submodule-content situation (an empty or absent directory), but `check-gitmodules-consistency.sh` will catch it precisely: `FAIL: .gitmodules declares '<path>' but no directory exists on disk`. The fix is the same `git submodule add <url> <path>` from the sequence above — it's safe to run even when `.gitmodules` already has a matching entry (git recognizes the existing declaration and won't duplicate it; it just creates the missing gitlink and clones the content).

**The takeaway:** after moving *any* plugin's path, don't reach for `sync && update --init` as the fix--all. That pair is for keeping already-tracked submodules current, not for registering a brand new path. `git submodule add` is the only command that actually creates a new gitlink.

### 3.3 Deciding start/ vs opt/, and how to lazy-load correctly

Default to `opt/` unless the plugin needs to be active from the very first keystroke (e.g. a statusline, a colourscheme companion). Every plugin currently in `opt/` got there because it was previously in `start/` and measurably added to every single startup regardless of whether it was used that session.

Three lazy-load patterns are already in use in this repo — copy whichever matches your plugin's shape:

**Pattern A — filetype-triggered** (for a plugin that's only relevant to specific file types, e.g. a linter):
```vim
" In ftplugin/<filetype>.vim, near the top, after the re-entry guard:
packadd <plugin>
```
Used for `autopep8`/`flake8`/`pydocstring` in `ftplugin/python.vim`, `shellcheck`/`shfmt` in `ftplugin/sh.vim`. Safe because `packadd` is idempotent (a harmless no-op if already loaded), and the ftplugin file already only runs for that filetype.

**Pattern B — command-stub** (for a plugin invoked via a specific `:Command`):
```vim
" In pack/plugins.vim:
command! FloatermToggle packadd floaterm | FloatermToggle
```
This does **not** recurse: `packadd` loads the real plugin, which redefines `:FloatermToggle` with its own implementation, so the `| FloatermToggle` segment on the same line resolves to that new definition, not back to the stub. (Verified with a throwaway test plugin before this pattern was adopted — see the commit history for `MundoToggle`/`FloatermToggle` if you want to see the proof.) Use this when you know the plugin's exact command name.

**Pattern C — manual only** (for a plugin with no existing keybinding/command to hook into, where you don't want to guess at its API):
```vim
" Just move it to opt/ with no trigger. Document it in pack/plugins.vim:
" Loadable via :packadd <plugin> when needed.
```
Used for `wordy` and `gv` — moved to `opt/` but deliberately given no automatic trigger, since guessing at an unfamiliar plugin's exact command surface risks silently breaking it.

**Do not** invent a fourth pattern without checking whether the plugin's functionality depends on its own `ftdetect/` running automatically — see the `vimwiki` case below.

### 3.4 The one plugin deliberately NOT lazy-loaded: vimwiki

`vimwiki` stays in `start/` on purpose, documented inline in `pack/plugins.vim`. The reason: its own filetype detection (recognizing `.wiki` files) lives in its own `ftdetect/`, which Vim only scans for an `opt/` package *after* that package has been `packadd`-ed — a chicken-and-egg problem. Moving it correctly requires this repo's own `BufNewFile,BufRead *.wiki` hook to `packadd` the plugin *before* its native detection would normally run, then re-fire detection for the buffer already open:
```vim
au BufNewFile,BufRead *.wiki ++once packadd vimwiki | doautocmd BufRead
```
This was deliberately not implemented without a way to verify it against the plugin's actual `ftdetect`/`ftplugin` behavior. If you want to revisit it, test thoroughly that `.wiki` files still get `filetype=wiki` applied correctly before trusting it.

---

## 4 · How to Add or Edit a `ftplugin/*.vim` File

Every one of the 12 existing files follows the same structure. Copy it exactly for a new filetype:

```vim
" <Filetype> filetype plugin

" ... ASCII art header (cosmetic, optional) ...

if exists("b:did_ftplugin")
  fini
en
let b:did_ftplugin = 1

" All settings MUST use setl/setlocal, never bare `set`.
setl ts=2
setl sts=2
setl shiftwidth=2

" All mappings MUST include <buffer>.
nnoremap <buffer> <F5> :!clear && somecommand %<CR>

" Helper functions should be script-local (s:) unless something outside
" this file needs to call them (e.g. `indentexpr` requires a global name).
function! s:MyHelper()
  " ...
endfunction
```

### Why both rules are load-bearing, not style preference

**The guard (`b:did_ftplugin`)** stops the whole file from re-running if the same buffer's filetype gets re-set. Without it, mappings/functions get redefined repeatedly on the same buffer — usually harmless for `nnoremap`/`function!` since they allow redefinition, but real waste, and it matters for anything that shouldn't run twice.

**`<buffer>` on every mapping and `setl` on every option** — without these, the setting leaks globally. This actually happened: `<F5>` was mapped globally (no `<buffer>`) in both `ftplugin/python.vim` (running `python3 %`) and `ftplugin/javascript.vim` (running `node %`). Opening a `.py` file then a `.js` file made `<F5>` run `node %` *even while editing the Python buffer*, because whichever filetype's ftplugin ran most recently silently won for the whole session. Same thing happened with `markdown.vim`'s `set ts=4` leaking tab-width into every other buffer opened afterward.

**Run this after editing any `ftplugin/*.vim` file:**
```bash
bash scripts/check-ftplugin-hygiene.sh
```
It checks exactly these three things (buffer-scoped mappings, `setl` not `set`, the guard present) and will fail loudly if you miss one.

### A subtler trap: `au!` inside an augroup defined in a per-buffer-firing file

If your ftplugin file defines an augroup (e.g. for a `WinEnter`/`BufEnter` highlight), **do not** put `au!` inside it if the augroup name is shared across all buffers of that filetype:

```vim
" WRONG -- au! here wipes out the buffer-local autocmd from any OTHER
" already-open buffer of this filetype, every time a new one opens.
aug MyHighlight
    au!
    au WinEnter,BufEnter <buffer> ...
aug END
```

This is real: it happened with the `TooLong` column-highlight augroups in `python.vim`/`sh.vim`/`tex.vim`/`vim.vim`. Since the file re-runs once per buffer but the augroup name is the same across all buffers of that filetype, `au!` cleared the *whole* augroup — including the entry for any other already-open buffer of the same type — every time you opened one more. Verified with a real two-buffer test: opening `buf1.py` then `buf2.py` silently removed `buf1`'s highlight.

**The fix:** drop the `au!` entirely and rely on the `b:did_ftplugin` guard (which already prevents the *same* buffer from re-registering) to keep things clean:
```vim
" RIGHT -- no au!, guard above already prevents same-buffer duplication.
aug MyHighlight
    au WinEnter,BufEnter <buffer> ...
aug END
```

If you're ever unsure whether this applies to a new augroup you're adding, test it directly:
```vim
" Open two buffers of the filetype, check the augroup's listing:
:au MyHighlight
```
Confirm you see one buffer-local entry per open buffer, not just the most recent one.

---

## 5 · Vimrc-Level Conventions

### Autocommands must be in a named augroup with `au!` — with the one exception above

Any autocommand defined directly in `vimrc` (not inside a per-buffer ftplugin file) should be wrapped:
```vim
augroup MyFeature
  au!
  au SomeEvent * ...
augroup END
```
Without this, reloading vimrc (`\sv`) stacks a duplicate copy of the autocommand every single time. This was a real bug across 8 different autocommands in `vimrc` before it was fixed — verified by sourcing vimrc three times and confirming each affected autocmd showed exactly one registered instance afterward, not three.

The distinction from §4's warning: `vimrc`'s augroups are defined **once per Vim session** (vimrc only loads once, or gets manually reloaded), so `au!` is correct and necessary there. `ftplugin` augroups fire **once per buffer**, which is the opposite situation.

### Environment variables: never assume `$DOTVIM`/`$DOTFILES` are set

```vim
if empty($DOTVIM)
  let $DOTVIM = expand('<sfile>:p:h')
endif
if empty($DOTFILES)
  let $DOTFILES = expand('~/.files')
endif
```
This guard exists near the top of `vimrc` because `vim -u vimrc` (bypassing the shell profile that normally exports these) used to throw 4 separate `E484` errors and silently skip loading `pack/plugins.vim`, `pack/lf.vim`, and both wordlist files. If you add a new `source $DOTVIM/...` or `source $DOTFILES/...` line anywhere, use the existing `s:SourceIfExists()` helper instead of a bare `source`, so a missing file warns instead of hard-erroring:
```vim
call s:SourceIfExists('$DOTVIM/path/to/file.vim')
```

### `$MYVIMRC` is not reliably set either

Confirmed empirically: `$MYVIMRC` is empty when Vim is launched via `-u <path>` rather than through its own default vimrc auto-discovery. Any mapping or function that reloads/edits "the vimrc" should fall back to `$DOTVIM/vimrc`:
```vim
exe 'source' fnameescape(!empty($MYVIMRC) ? $MYVIMRC : $DOTVIM . '/vimrc')
```

### Never add an autocommand that runs `sudo`

This repo used to have `au BufWinLeave $DOTFILES/bash/crontab :!sudo cp % /etc/crontab` — an unprompted privileged file copy triggered just by switching windows away from that buffer. Removed for the obvious reason. `scripts/check-security-regressions.sh` specifically checks for this pattern (any autocmd-triggered `sudo`) and will fail CI if it comes back. A **mapping** that requires an explicit keypress and shows a real sudo prompt (like the existing `<S-F6>` dos2unix mapping) is a different, acceptable risk category — the check only flags autocmd-triggered, unprompted sudo.

### GPG-encrypted file handling

The `GPGSafety` augroup in `vimrc` disables `undofile`/`backup`/`swapfile`/clipboard-sync specifically for `*.gpg`/`*.asc`/`*.pgp` buffers, independent of whatever `vim-gnupg` itself does. **Do not remove or weaken this** — without it, editing an encrypted file can write the *decrypted* plaintext to `$DOTVIM/.tmp/undodir` or `$DOTVIM/.tmp/backupdir` on disk, or leak it into the system clipboard. If you add support for another encrypted-file extension, extend the existing augroup's file-pattern list rather than creating a new mechanism. `scripts/check-security-regressions.sh` checks this is still present and correctly configured.

---

## 6 · CI/CD Reference

### What runs when

| Workflow | Trigger | What it does |
|---|---|---|
| `validate.yml` | every push/PR | Startup smoke test (Ubuntu + macOS matrix), `.gitmodules` consistency, ftplugin hygiene, vint lint |
| `security-scan.yml` | every push/PR | Secret scanning (gitleaks) + hand-fixed security regression check |
| `sync-plugins.yml` | daily 03:00 UTC | Delegates to an **external** repo's workflow (`duc-mt/dotfiles`) which runs `git submodule update --remote` and **pushes straight to `master`, no PR, no review** |
| `nightly-plugin-compat.yml` | daily 01:00 UTC | Previews what tonight's 03:00 sync would produce, in a scratch checkout that's never pushed. Opens/updates a tracking issue if it would break something |
| `post-sync-validate.yml` | after `sync-plugins.yml` completes | Re-validates `master` *after* the unreviewed push has already landed. Opens/updates a tracking issue on failure |
| `startup-benchmark.yml` | push to `master` | Records median startup time as an artifact + step summary. Never fails the build (CI timing is noisy) — compare artifacts across runs to spot creeping regressions |

### The one thing to understand about the sync workflow

**`sync-plugins.yml` bypasses `validate.yml` entirely.** It's a separate trigger (`schedule`, not `push`/`pull_request`), and the workflow it delegates to pushes directly to `master` with no PR. This means a bad upstream plugin commit *can* land on `master` unreviewed. `nightly-plugin-compat.yml` and `post-sync-validate.yml` exist specifically to give you advance warning (before 03:00) and after-the-fact warning (after the push), respectively — but neither of them *prevents* the push. If you want a harder gate, the actual fix is upstream: changing what `duc-mt/dotfiles/.github/workflows/sync-submodules.yml` does, which is out of this repo's control.

If either of those two workflows opens a `nightly-sync-would-break` or `auto-sync-broken` issue, treat it as urgent — it means either tonight's sync will break things, or a broken sync already landed on `master`.

### Updating pinned Action SHAs

Every `uses: owner/repo@<sha> # vX.Y.Z` reference across every workflow is pinned to a full commit SHA, not a mutable tag or branch. Dependabot (`.github/dependabot.yml`) will propose updates automatically. If you ever need to update one by hand:
```bash
git ls-remote https://github.com/<owner>/<repo>.git refs/tags/<new-version>
# Use the SHA it returns -- never guess or transcribe from memory.
# (This caught a real 2-character transcription error during this
# repo's CI setup -- verify every time, even when a SHA looks plausible.)
```

### vint's known limitations

**Parser limitation:** `vint` cannot parse `vimrc` at all — it hits a parser error on the pre-existing `0o700` octal literal (used for `mkdir` permissions) and aborts linting the *entire file* on that one line, not just that construct. This is a `vint` limitation, not a bug in `vimrc` — the code is valid, working Vimscript. `scripts/run-vint.sh` reports this as informational only and does not fail the build because of it. `vint` *does* successfully lint `pack/plugins.vim`, `pack/lf.vim`, and every `ftplugin/*.vim` file, and failures there **do** block CI. If `vint`'s upstream (`vim-vimlparser`) ever adds support for this octal syntax, `vimrc` linting will start working automatically — no config change needed here.

**Dependency fragility (a real CI incident, not hypothetical):** `vim-vint` (last released as version 0.3.21, showing no sign of active maintenance) imports the deprecated `pkg_resources` module. When `validate.yml`'s `vimscript-lint` job ran on a fresh runner with the newest available `setuptools`, that job failed outright with `ModuleNotFoundError: No module named 'pkg_resources'` — `setuptools` 81+ dropped `pkg_resources` entirely. The fix (already applied) pins the install:
```bash
pip install "setuptools<81"
pip install vim-vint
```
**This is explicitly a time-bounded workaround, not a permanent fix.** `pkg_resources` itself is slated for full removal from Python packaging as early as 2025-11-30 (per `setuptools`' own deprecation warning), at which point pinning an old `setuptools` may stop being installable or stop working at all. If `vimscript-lint` starts failing again with a `pkg_resources`-related error, check first whether a `vim-vint` release newer than 0.3.21 exists and has addressed this upstream, before assuming the pin just needs adjusting further — it may be time to replace `vint` with an actively-maintained alternative instead.

### Running any CI check locally before pushing

Every check CI runs has a corresponding script — run it yourself first:
```bash
bash scripts/startup-smoke-test.sh          # matches validate.yml's core check
bash scripts/ftplugin-open-test.sh          # opens every filetype in one session
bash scripts/check-gitmodules-consistency.sh
bash scripts/check-ftplugin-hygiene.sh
bash scripts/run-vint.sh                    # requires: pip install "setuptools<81" vim-vint
bash scripts/check-security-regressions.sh
bash scripts/check-nightly-plugin-compat.sh # WARNING: mutates your local submodule checkouts to their latest upstream commits (matches what the real sync would do) -- don't run this on a checkout you care about keeping pinned
bash scripts/measure-startup-time.sh [N]    # prints median ms over N runs (default 5)
```

---

## 7 · Troubleshooting

### `fatal: No url found for submodule path '...' in .gitmodules`

You (or a patch) moved a plugin's path in `.gitmodules` text without properly relocating the actual git submodule. See §3.2 for the full fix. Quick version:
```bash
git submodule deinit -f <old-path>
git rm -f <old-path>
rm -rf .git/modules/<old-path>
# then re-add at the new path per .gitmodules
```
Run `bash scripts/check-gitmodules-consistency.sh` to confirm it's fully resolved.

### `check-gitmodules-consistency.sh` fails with `.gitmodules declares '<path>' but no directory exists on disk`, on a fresh checkout

**This happened for real, across 12 plugins simultaneously, after an earlier plugin-reorganization patch was applied.** This is the *other* half of §3.2's second failure mode — distinct from the `fatal: No url found` error above, and easy to confuse with it. Here, `.gitmodules` and the git index actually agree on nothing being wrong syntactically — the real problem is that the *new* path's gitlink was simply never created in the first place. This happens if someone runs `git submodule sync && git submodule update --init --recursive` as the fix after a plugin move, instead of `git submodule add <url> <path>` — the former only refreshes submodules that are already tracked; it can't register a brand new path.

**Fix, for each affected path:**
```bash
rmdir <path> 2>/dev/null   # remove a stray empty placeholder dir if present
git submodule add <url> <path>   # url comes from the existing .gitmodules entry
```
Then confirm with `bash scripts/check-gitmodules-consistency.sh` — it should report every path as consistent. `git submodule add` is safe to run even though `.gitmodules` already declares the path; git recognizes the existing entry and won't duplicate it, it just creates the missing gitlink and clones the real content.

### A mapping does the wrong thing depending on what filetype I opened last

This is the buffer-scoping bug class from §4. Find the offending mapping:
```bash
bash scripts/check-ftplugin-hygiene.sh
```
It will name the exact file and line. Add `<buffer>` (for mappings) or change `set` to `setl` (for options).

### Vim throws `E484: Can't open file /pack/plugins.vim` (or similar, with a leading `/`)

`$DOTVIM` is unset or empty, so `$DOTVIM/pack/plugins.vim` evaluated to `/pack/plugins.vim`. This should be impossible now (the guard in §5 sets a fallback), but if you see it, check whether something *removed* that guard, or whether you're sourcing `vimrc` in a way that bypasses the top of the file (e.g. `:source` on a partial file, not the whole thing).

### `E919: Directory not found in 'packpath'` / `E185: Cannot find color scheme 'gruvbox-material'` in CI, even though submodules checked out correctly

This happened for real in CI once already, and looked exactly like the "shallow checkout, missing submodule content" caveat the smoke-test scripts print — but wasn't that. The actual cause: **`vim -Nu ./vimrc` never adds the checkout directory itself to `&packpath`/`&runtimepath`**, unlike a real `~/.vim/vimrc` install where `~/.vim` is one of Vim's own default runtimepath entries regardless of vimrc content. Without it, every `packadd <opt-plugin>` call fails, because Vim has nowhere to actually find `pack/*/opt/<plugin>` — even when that directory genuinely exists with real content, checked out correctly by `submodules: recursive`.

Confirmed by reproduction, not guessed: placing real-looking plugin content directly in a local checkout and running the bare invocation still failed the same way; adding `--cmd "set packpath+=$(pwd)" --cmd "set runtimepath+=$(pwd)"` to the same invocation with the same content in place fixed it immediately.

**This is already fixed** in `scripts/startup-smoke-test.sh` and `scripts/ftplugin-open-test.sh` (both add the repo root to `packpath`/`runtimepath` explicitly before invoking Vim). If you write a *new* script that invokes `vim -Nu ./vimrc` directly, copy that same pattern — don't assume a bare `-u` invocation behaves like a real installed config.

If you see this error and it's *not* from a new custom script missing this pattern, then the original caveat still applies: check whether the workflow step actually used `submodules: recursive` on checkout.

### A highlight/behavior only shows up in the most-recently-opened buffer of a filetype, not all of them

This is the `au!`-inside-a-shared-augroup bug from §4's subtler trap. Check whether the augroup is defined inside a `ftplugin/*.vim` file (fires per-buffer) and contains `au!` — if so, remove the `au!` and rely on the file's `b:did_ftplugin`/`b:did_indent` guard instead.

### Opening a `.gpg`/`.asc`/`.pgp` file, then checking `:set undofile? backup? swapfile?` shows they're still on

The `GPGSafety` augroup (see §5) isn't matching your file, or has been removed/broken. Run:
```bash
bash scripts/check-security-regressions.sh
```
It checks specifically for this. If it passes but the buffer still shows the settings on, check whether your file's extension matches the augroup's pattern (`*.gpg,*.asc,*.pgp`) — if you're using a different encrypted-file convention, extend the pattern rather than adding a parallel mechanism.

### Startup feels slower than it used to

```bash
bash scripts/measure-startup-time.sh 5
```
Compare against recent `startup-benchmark.yml` artifacts in the Actions history for `master`. If a specific recent plugin addition is the suspect, temporarily move it to `opt/` (§3.3) and re-measure to confirm before committing to a permanent fix.

### CI's `vimscript-lint` job fails

Check whether the failure is in `vimrc` specifically — if so, and it's the `0o700` parse error, that's the known, non-blocking limitation from §6, and shouldn't be failing the build at all (if it is, something changed in `scripts/run-vint.sh`'s handling — check it hasn't regressed). If the failure is in `pack/plugins.vim`, `pack/lf.vim`, or a `ftplugin/*.vim` file, it's a real `vint`-detected error (not a style warning — those are already suppressed via `.vintrc.yaml`) and needs an actual fix.

### A scheduled sync broke `master`

Check for an open issue labeled `auto-sync-broken` (opened automatically by `post-sync-validate.yml`) or `nightly-sync-would-break` (opened by `nightly-plugin-compat.yml`, meaning it was caught *before* landing). To find and revert the specific bad commit:
```bash
git log -1 --format=%H master   # the sync commit, if it already landed
git revert <that-sha>
```
To identify which specific submodule caused it, compare `git submodule status` before and after that commit, or re-run `bash scripts/check-nightly-plugin-compat.sh` locally (on a disposable checkout — it mutates submodule state) to reproduce and bisect.

### A patch fails to apply with `git apply`

Almost always one of two things:
1. **Trailing whitespace warning** — usually harmless (`git apply` still applies the patch; it's a warning, not an error). Confirm with `git status` that all expected files show as modified.
2. **Actual conflict** — your local file has diverged from what the patch expects. Run `git apply --check <patch>` first (dry run, no changes) to see the real error before attempting a real apply.

---

## 8 · Quick Reference — Before You Commit

```bash
# The minimum bar for any change:
bash scripts/startup-smoke-test.sh

# If you touched .gitmodules or moved anything under pack/:
bash scripts/check-gitmodules-consistency.sh

# If you touched any ftplugin/*.vim file:
bash scripts/check-ftplugin-hygiene.sh

# If you touched vimrc, pack/plugins.vim, pack/lf.vim, or any ftplugin file
# and want the full Vimscript lint (requires: pip install "setuptools<81" vim-vint):
bash scripts/run-vint.sh

# If you touched anything security-sensitive (autocommands, GPG handling):
bash scripts/check-security-regressions.sh
```

All of the above run automatically on every push/PR via `validate.yml` and `security-scan.yml` — running them locally first just means you find out before CI does, not instead of it.
