#!/bin/bash
set -e
set -x

[ -z "$REBUILD_ALL" ] && REBUILD_ALL=0

REBUILD_ALL=$REBUILD_ALL CRYPTO_BACKEND="nettle" $HOME/blackfuel/cryptsetup-arm-asuswrt/cryptsetup.sh
REBUILD_ALL=$REBUILD_ALL $HOME/blackfuel/ntp-arm-asuswrt/ntp.sh
REBUILD_ALL=$REBUILD_ALL $HOME/blackfuel/dnscrypt-arm-asuswrt/dnscrypt.sh
REBUILD_ALL=$REBUILD_ALL $HOME/blackfuel/wipe-arm-asuswrt/wipe.sh
REBUILD_ALL=$REBUILD_ALL $HOME/blackfuel/haveged-arm-asuswrt/haveged.sh
REBUILD_ALL=$REBUILD_ALL $HOME/blackfuel/rngtools-arm-asuswrt/rngtools.sh
REBUILD_ALL=$REBUILD_ALL $HOME/blackfuel/dieharder-arm-asuswrt/dieharder.sh

# update the staging area
rsync -avh --existing --delete-after $HOME/blackfuel/asuswrt-merlin-addon/asuswrt/* $HOME/blackfuel/asuswrt-merlin-addon/staging
cp -a $HOME/blackfuel/asuswrt-merlin-addon/staging/native/sbin $HOME/blackfuel/asuswrt-merlin-addon/staging

# strip binaries
arm-brcm-linux-uclibcgnueabi-strip \
  $HOME/blackfuel/asuswrt-merlin-addon/staging/bin/* \
  $HOME/blackfuel/asuswrt-merlin-addon/staging/sbin/* \
  $HOME/blackfuel/asuswrt-merlin-addon/staging/usr/bin/* \
  $HOME/blackfuel/asuswrt-merlin-addon/staging/lib/*
