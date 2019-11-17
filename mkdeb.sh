#!/bin/sh

if [ $# -ne 6 ]; then
    echo "usage <dir> <package-name> <package-ver> <package-rev> <author-name> <author-email>"
    exit 1
fi

DIR="${1}"
PN="${2}"
PV="${3}"
PR="${4}"
AUTHOR_NAME="${5}"
AUTHOR_EMAIL="${6}"

set -e

cd "${DIR}"
mkdir -p DEBIAN
echo "Package: ${PN}" > DEBIAN/control
echo "Version: ${PV}-${PR}" >> DEBIAN/control
echo "Section: base" >> DEBIAN/control
echo "Priority: optional" >> DEBIAN/control
echo "Architecture: `dpkg --print-architecture`" >> DEBIAN/control
#RUN echo "Depends: " >> DEBIAN/control
echo "Maintainer: ${AUTHOR_NAME} <${AUTHOR_EMAIL}>" >> DEBIAN/control
echo "Description: ${PN}" >> DEBIAN/control
echo " ${PN}" >> DEBIAN/control
cd "${OLDPWD}"
dpkg-deb --build "${DIR}"
