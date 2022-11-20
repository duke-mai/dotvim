#!/usr/bin/python3
# -*- coding: utf-8 -*-

# =============================================================================
#
#        FILE:  read_english_dictionary.py
#      AUTHOR:  Tan Duc Mai
#       EMAIL:  tan.duc.work@gmail.com
#     CREATED:  04-May-2022
# DESCRIPTION:  Open a word file in the current directory and read from it.
#      SOURCE:  https://raw.githubusercontent.com/dwyl/english-words/master/read_english_dictionary.py
#
# =============================================================================

# ------------------------------- Module Imports ------------------------------
import os
import platform
from rich.traceback import install; install(show_locals=True)


# ---------------------------- Function Definition ----------------------------
def load_files():
    if platform.system() == 'Linux':
        command = 'ls -l'
    elif platform.system() == 'Windows':
        command = 'dir'
    print(os.system(command))


def load_words():
    with open('common.txt') as word_file:
        valid_words = set(word_file.read().split())
    return valid_words


# ------------------------------- Main Function -------------------------------
def main():
    # Print all files in current directory.
    load_files()
    # Print all words.
    print(load_words())
    # Check if a word is there.
    print('fate' in load_words())


# --------------------------- Call the Main Function --------------------------
if __name__ == '__main__':
    main()
