#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)
DOCKER_ROOT=`cd $THISDIR/..; pwd`
WORKSPACE_ROOT=`cd $THISDIR/..; pwd`

source "$WORKSPACE_ROOT/.env"

# get the notebook token from the logs
echo
echo
echo The URLs shown below will allow you to login to the Jupyter container:
"$THISDIR/d-compose.sh" --env-file "$WORKSPACE_ROOT/.env" logs --tail 10000 notebooks | grep -E "http://[a-zA-Z0-9\.]+:[0-9]+.*\?token="
echo