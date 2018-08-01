#!/bin/sh
# fosscad-download.sh
# Download the latest official FOSSCAD repository to a local file, for distribution purposes. Compressed archive is prepared by the Github site and downloaded by this script.
set -e
set -x

VERSION=$(wget -q -O - https://raw.githubusercontent.com/maduce/fosscad-repo/master/README.md | grep -A 3 "# Version" | grep -P '\*\s+[0-9]+\.[0-9]+\s+.*' | sed -r 's/\*\s+([0-9]+\.[0-9]+)\s+.*$/\1/')
[ -z "$VERSION" ] && echo "cannot retrieve the release version number" && exit 1

SOURCE_VERSION=`git ls-remote https://github.com/maduce/fosscad-repo | grep HEAD | cut -f1`
[ -z "$SOURCE_VERSION" ] && echo "cannot retrieve the git commit hash" && exit 1

SOURCE_TIMESTAMP_X=$(wget -q -O - https://api.github.com/repos/maduce/fosscad-repo/git/commits/${SOURCE_VERSION} | grep -A 4 '"author": {' | grep '"date":' | cut -d'"' -f4)
SOURCE_TIMESTAMP=$(date +@%s -d "$SOURCE_TIMESTAMP_X" 2>/dev/null || date +@%s -D %Y-%m-%dT%H:%M:%S%Z -d "$SOURCE_TIMESTAMP_X")

FILENAME="FOSSCAD_MEGA_PACK_v${VERSION}+git-${SOURCE_VERSION}"

[ ! -f ${FILENAME}.zip ] && wget -O ${FILENAME}.zip https://github.com/maduce/fosscad-repo/archive/master.zip && touch -d $SOURCE_TIMESTAMP ${FILENAME}.zip

[ ! -f ${FILENAME}.tar.gz ] && wget -O ${FILENAME}.tar.gz https://github.com/maduce/fosscad-repo/archive/master.tar.gz && touch -d $SOURCE_TIMESTAMP ${FILENAME}.tar.gz

