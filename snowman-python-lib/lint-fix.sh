#!/bin/sh
# https://github.com/hhatto/autopep8#usage
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)
autopep8 --in-place --aggressive --aggressive --recursive "$THISDIR/src/snowman"
