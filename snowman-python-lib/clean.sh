#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)

find "$THISDIR" -name '*.pyc' -exec rm -vf {} \;

rm -rfd "$THISDIR/src/build"
rm -rfd "$THISDIR/src/snowman.egg-info"
