#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)
# https://docs.python.org/3/library/unittest.html#unittest-test-discovery
python3 -m unittest discover -v -s "$THISDIR/src"

