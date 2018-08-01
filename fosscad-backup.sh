#!/bin/sh
# fosscad-backup.sh
# Download the latest official FOSSCAD repository to a local file, for backup and mirror support. Compressed archive is created by this script.
set -e
set -x
unset BACKUP_NEEDED
if [ ! -d fosscad-repo ]; then
  git clone https://github.com/maduce/fosscad-repo
  cd fosscad-repo
  git checkout master
  git submodule update --init --recursive
  BACKUP_NEEDED=1
else
  PULL_NEEDED=$(git fetch --dry-run 2>&1 | wc -c)
  if [ $PULL_NEEDED -gt 0 ]; then
    cd fosscad-repo
    git pull
    git submodule update --init --recursive
    BACKUP_NEEDED=1
  fi
fi
if [ -n $BACKUP_NEEDED ]; then
  SOURCE_VERSION=`git ls-remote https://github.com/maduce/fosscad-repo | grep HEAD | cut -f1`
  [ -z "$SOURCE_VERSION" ] && SOURCE_VERSION="missing_git_source_version"
  SOURCE_TIMESTAMP="`git log -1 --format='@%ct'`"
  VERSION=$(grep -A 3 "# Version" README.md | grep -P '\*\s+[0-9]+\.[0-9]+\s+.*' | sed -r 's/\*\s+([0-9]+\.[0-9]+)\s+.*$/\1/')
  [ -z "$VERSION" ] && VERSION="N.N"
  FOLDER_NAME="FOSSCAD_MEGA_PACK_v${VERSION}+git-${SOURCE_VERSION}"
  cd ..
  rsync -av --progress fosscad-repo/ ${FOLDER_NAME} --exclude .git

  # make tar+xz archive (Linux)
  chmod -R g-w,o-w ${FOLDER_NAME}
  tar --numeric-owner --owner=0 --group=0 --sort=name --mtime=$SOURCE_TIMESTAMP -cv ${FOLDER_NAME} | xz -zc -7e > ${FOLDER_NAME}.tar.xz
  touch -d $SOURCE_TIMESTAMP ${FOLDER_NAME}.tar.xz

  # make zip archive (Windows)
  find ${FOLDER_NAME}/ -exec touch -d $SOURCE_TIMESTAMP {} +
  zip -r -c ${SOURCE_VERSION} ${FOLDER_NAME}.zip ${FOLDER_NAME}
  touch -d $SOURCE_TIMESTAMP ${FOLDER_NAME}.zip

  rm -rf ${FOLDER_NAME}
fi

