#! /usr/bin/env python3
'''
renames files or folders, changing all uppercase characters to lowercase.
directories will be parsed recursively.

usage: python3 dir_tolower.py file|directory
'''
import sys, os
def lowercase_rename(dir):
    def rename_all(root, items):
        for name in items:
            os.rename(os.path.join(root, name), os.path.join(root, name.lower()))
    for root, dirs, files in os.walk(dir, topdown=False ):
        rename_all(root, dirs)
        rename_all(root, files)
    os.rename(dir, dir.lower())
lowercase_rename(sys.argv[1])
