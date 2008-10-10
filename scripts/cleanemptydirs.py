#!/usr/bin/env python

"""find empty dirs"""

import os
from os.path import join, getsize
for root, dirs, files in os.walk('.'):
    for ignoredir in ('CVS','.svn','.git','eclass'):
        if ignoredir in dirs:
            dirs.remove(ignoredir)
    if len(dirs)+len(files) == 0:
        print root, "seems to be empty"
