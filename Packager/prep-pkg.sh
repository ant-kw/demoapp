#!/usr/bin/env bash
set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'if [ $? -ne 0 ]; then echo "\"${last_command}\" command filed with exit code $?."; fi' EXIT

BLUE="\033[01;34m"
YELLOW="\033[01;33m"
GREEN="\033[01;32m"
RED="\033[01;31m"
NORM="\033[00m"


error() {
	echo -en "\n${RED}[!]${NORM} ${1}\n"
	exit 1
}

warn() {
	echo -en "\n${YELLOW}[w]${NORM} ${1}"
}

info() {
	echo -en "\n${BLUE}[i]${NORM} ${1}"
}


if [ ! -z $APP ]; then
	APP=$APP
else
	error " APP name is required"
fi


if [ ! -z $VERSION ]; then
	VERSION=$VERSION
else
	error " VERSION is required"
fi


PLATF=${1:-linux}
ARCH=${2:-amd64}

info "Preparing package for ${GREEN}${APP} ${VERSION}${NORM} for ${GREEN}${PLATF}${NORM} on ${GREEN}${ARCH}${NORM}...\n"

## Logic here
## Get source for a package at requested version

## Perform tasks to prep for packaing here - prep venv etc

info "Creating deb Package: "
fpm -s dir -t deb -n ${APP} -v ${VERSION} -a ${ARCH} --deb-changelog /tf/${VERSION}/changelog.md -p ${OUTPATH}/deb ${EXPATH}/=/usr/bin > /dev/null 2>&1 && echo "[OK]" || error " ERROR"

# Changelog omitted from RPM because not correct format
info "Creating RPM Package: "
fpm -s dir -t rpm -n ${APP} -v ${VERSION} -a ${ARCH} -p ${OUTPATH}/rpm ${EXPATH}/=/usr/bin > /dev/null 2>&1 && echo -en "[OK]\n" || error " ERROR"


