#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)
DOCKER_ROOT=`cd $THISDIR/..; pwd`
WORKSPACE_ROOT=`cd $THISDIR/..; pwd`

source "$WORKSPACE_ROOT/.env"

echo SNOWFLAKE_URL is $SNOWFLAKE_URL

echo "using workspace file $WORKSPACE_ROOT/.env"
"$THISDIR/d-compose.sh" --env-file "$WORKSPACE_ROOT/.env" up -d

# get the notebook token from the logs (but sleep a moment first so the logs exist)
printf "Giving Jupyter a few seconds to start up.."
SECS=5
while [ $SECS -gt 0 ]; do
  printf "."
  sleep 1
  SECS=`expr $SECS - 1`
done

"$THISDIR/show-token.sh"
