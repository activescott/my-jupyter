#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)
DOCKER_ROOT=`cd $THISDIR/..; pwd`
WORKSPACE_ROOT=`cd $THISDIR/..; pwd`

source "$WORKSPACE_ROOT/.env"

# More configuration at https://github.com/ml-tooling/ml-workspace#configuration-options
"$THISDIR/stop.sh"
"$THISDIR/d-compose.sh" build --no-cache $@
