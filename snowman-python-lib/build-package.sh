#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)

die () {
    echo "*** ERROR ***"
    echo >&2 "ERROR: $@"
    exit 1
}

# display current published versions:
PUBLISH_DIR=$(cd "${THISDIR}/../.devcontainer/docker-scripts/snowman-python-lib-install/"; pwd)
echo "Current published versions: "
for WHL in $PUBLISH_DIR/snowman-*.whl; do
    echo "  `basename $WHL`"
done
echo ""

THEVERSION=
read -p 'Enter the version number (0.0.0): ' THEVERSION
[ -z "$THEVERSION" ] && THEVERSION=0.0.0
echo "Building version ${THEVERSION}..."

CONSTANTS="$THISDIR/src/snowman/constants.py"
[ -f "$CONSTANTS" ] || die "constants.py not at $CONSTANTS!"
sed -E -e "s/PKG_VERSION ?=.*$/PKG_VERSION='$THEVERSION'/" "$CONSTANTS" > $CONSTANTS.tmp && mv $CONSTANTS.tmp $CONSTANTS

pushd .
cd "$THISDIR/src"
python3 setup.py bdist_wheel
RETCODE=$?
popd
if [ "$RETCODE" -ne "0" ]; then
	die 'python setup failed'
fi

echo; echo cleaning...
"$THISDIR/clean.sh"
echo cleaning complete.; echo

echo 

WHEEL_FILENAME=snowman-${THEVERSION}-py3-none-any.whl
if [ ! -f "${THISDIR}/src/dist/${WHEEL_FILENAME}" ]; then
    die "Expected ${WHEEL_FILENAME} to be at ${THISDIR}/src/dist !"
fi
echo "Version \"$THEVERSION\" built at ${THISDIR}/src/dist/${WHEEL_FILENAME}"
echo "**********************************"

####################
# PUBLISH?
while true; do
    printf "\n"
    read -p "Do you want to publish to docker image and rebuild the image? (yes or no)" yn
    case $yn in
        [Yy]* ) 
            echo "\npublishing..."
            "$THISDIR/publish-package-to-docker-image.sh" "$THEVERSION"
            break
            ;;
        [Nn]* ) 
            exit
            ;;
        *) 
            echo "Please answer yes or no."
            ;;
    esac
done
