#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)
DOCKER_ROOT=`cd $THISDIR/..; pwd`
WORKSPACE_ROOT=`cd $THISDIR/../..; pwd`

source "$WORKSPACE_ROOT/.env"

npx @devcontainers/cli build --workspace-folder "$WORKSPACE_ROOT"
