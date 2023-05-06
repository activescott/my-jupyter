#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)

die () {
    echo >&2 "$@"

    exit 1
}

rm -rf ./.gitconfig .ssh/ .vscode-server/