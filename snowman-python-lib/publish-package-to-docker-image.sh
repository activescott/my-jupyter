#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)

die () {
    echo >&2 "$@"
    exit 1
}

SEMVER_REGEX='^[0-9]+\.[0-9]+\.[0-9]+$'
if [ "$#" -ge 1 ]; then
    THEVERSION=$1
else
    THEVERSION=
    read -p 'Enter the version number (e.g. 0.0.0): ' THEVERSION
fi
# validate format:
echo $THEVERSION | grep -E -q "$SEMVER_REGEX" || die "Version must match $SEMVER_REGEX, but $1 provided."


echo "\nPublishing version ${THEVERSION}..."

WHEEL_FILENAME=snowman-${THEVERSION}-py3-none-any.whl
PUBLISH_DIR=$(cd "${THISDIR}/../.devcontainer/docker-scripts/snowman-python-lib-install/"; pwd)
BUILD_DIR="${THISDIR}/src/dist"

if [ ! -f "${BUILD_DIR}/${WHEEL_FILENAME}" ]; then
    die "Expected ${WHEEL_FILENAME} to be at ${BUILD_DIR} !"
fi

cp -v "$BUILD_DIR/${WHEEL_FILENAME}" "$PUBLISH_DIR/${WHEEL_FILENAME}"

# poke the right version into the dockerfile
DOCKERFILE_DIR=$(cd "${THISDIR}/../.devcontainer/"; pwd)
DOCKERFILE="$DOCKERFILE_DIR/notebooks.Dockerfile"

# ARG SNOWMAN_VERSION=0.0.1
sed -E -e "s/ARG SNOWMAN_VERSION=.*$/ARG SNOWMAN_VERSION=$THEVERSION/" "$DOCKERFILE" > $DOCKERFILE.tmp && mv $DOCKERFILE.tmp $DOCKERFILE

# rebuild the docker image
echo "\nPublishing to image complete. Building image..."

DOCKER_SCRIPTS_DIR=$(cd "${THISDIR}/../.devcontainer/host-scripts/"; pwd)
"$DOCKER_SCRIPTS_DIR/docker-build.sh"
echo "\nrebuilding image complete."