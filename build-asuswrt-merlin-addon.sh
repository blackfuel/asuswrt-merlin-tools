#!/bin/bash
set -e
set -x

#REBUILD_ALL=0 CRYPTO_BACKEND="kernel" ~/blackfuel/cryptsetup-arm-asuswrt/cryptsetup.sh
REBUILD_ALL=0 CRYPTO_BACKEND="nettle" ~/blackfuel/cryptsetup-arm-asuswrt/cryptsetup.sh
#REBUILD_ALL=0 CRYPTO_BACKEND="openssl" ~/blackfuel/cryptsetup-arm-asuswrt/cryptsetup.sh
#REBUILD_ALL=0 CRYPTO_BACKEND="gcrypt" ~/blackfuel/cryptsetup-arm-asuswrt/cryptsetup.sh
REBUILD_ALL=0 ~/blackfuel/ntp-arm-asuswrt/ntp.sh
REBUILD_ALL=0 ~/blackfuel/dnscrypt-arm-asuswrt/dnscrypt.sh

# update the staging area
rsync -avh --existing --delete-after $HOME/blackfuel/asuswrt-merlin-addon/asuswrt/* $HOME/blackfuel/asuswrt-merlin-addon/staging
cp -a $HOME/blackfuel/asuswrt-merlin-addon/staging/native/sbin $HOME/blackfuel/asuswrt-merlin-addon/staging
