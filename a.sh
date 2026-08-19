#!/usr/bin/bash

# ======================================================================================
#
#         FILE:  script
#
#        USAGE:  ./script [-d] [-l] [-h] [starting directory]
#
#  DESCRIPTION:  List and/or delete all stale links in directory trees.
#                The default starting directory is the current directory.
#                Don’t descend directories on other filesystems.
#
#      OPTIONS:  see function ’usage’ below
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Duke Mai <henryfromvietnam@gmail.com>
#      COMPANY:  Eynesbury Institute of Business and Technology (EIBT)
#      VERSION:  1.0
#      CREATED:  Mar 29, 2022
#     REVISION:  ---
#
# ======================================================================================

cd ~/.vim

declare -A missing_submodules=(
  ["pack/git/opt/gv"]="https://github.com/junegunn/gv.vim.git"
  ["pack/syntax/opt/flake8"]="https://github.com/nvie/vim-flake8.git"
  ["pack/plugins/opt/floaterm"]="https://github.com/voldikss/vim-floaterm.git"
  ["pack/syntax/opt/autopep8"]="https://github.com/tell-k/vim-autopep8.git"
  ["pack/syntax/opt/pydocstring"]="https://github.com/heavenshell/vim-pydocstring.git"
  ["pack/syntax/opt/shellcheck"]="https://github.com/itspriddle/vim-shellcheck.git"
  ["pack/writing/opt/wordy"]="https://github.com/preservim/vim-wordy.git"
  ["pack/colours/opt/colorSchemeExplorer"]="https://github.com/jlanzarotta/colorSchemeExplorer.git"
  ["pack/file-system/opt/mundo"]="https://github.com/simnalamburt/vim-mundo.git"
  ["pack/syntax/opt/shfmt"]="https://github.com/z0mbix/vim-shfmt.git"
  ["pack/colours/opt/colorizer"]="https://github.com/lilydjwg/colorizer"
  ["pack/colours/opt/awesome-vim-colorschemes"]="https://github.com/rafi/awesome-vim-colorschemes"
)

for path in "${!missing_submodules[@]}"; do
  url="${missing_submodules[$path]}"
  rmdir "$path" 2>/dev/null
  git submodule add "$url" "$path"
done

bash scripts/check-gitmodules-consistency.sh   # should report clean

git add -A
git commit -m "fix: add missing submodule gitlinks for plugins moved to opt/"
git push
