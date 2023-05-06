#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)
WORKSPACE_ROOT=`cd $THISDIR/..; pwd`
DOCKER_ROOT=`cd $WORKSPACE_ROOT/.devcontainer; pwd`

source "$WORKSPACE_ROOT/.env"

# basically all this does is is invoke docker-compose with the right initial docker-compose.yml and whatever args are passed along...
DOCKER_ROOT="$DOCKER_ROOT" docker-compose -f "$DOCKER_ROOT/docker-compose.yml" $@
