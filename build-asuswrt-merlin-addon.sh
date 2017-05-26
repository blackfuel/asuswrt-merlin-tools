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
REBUILD_ALL=$REBUILD_ALL $HOME/blackfuel/rtlentropy-arm-asuswrt/rtlentropy.sh

# strip the binaries
strip_file() {
  for PATHNAME in $@; do
    if [ ! -h "$PATHNAME" ] && [ -f "$PATHNAME" ]; then
      FILESTR="$(file $PATHNAME)"
      EXECUTABLE=0
      echo "$FILESTR" | grep -q "ELF 32-bit LSB" && EXECUTABLE=1
      if [ $EXECUTABLE -eq 1 ]; then
        echo "stripping $PATHNAME"
        chmod a+w "$PATHNAME"
        arm-brcm-linux-uclibcgnueabi-strip -p "$PATHNAME"
        if [ -n "$(patchelf --print-rpath $PATHNAME)" ]; then
          patchelf --set-rpath "" "$PATHNAME"
        fi
      fi
    fi
  done
}

set +x
strip_file "$HOME/blackfuel/asuswrt-merlin-addon/asuswrt/bin/*" \
           "$HOME/blackfuel/asuswrt-merlin-addon/asuswrt/sbin/*" \
           "$HOME/blackfuel/asuswrt-merlin-addon/asuswrt/lib/*" \
           "$HOME/blackfuel/asuswrt-merlin-addon/asuswrt/usr/bin/*" \
           "$HOME/blackfuel/asuswrt-merlin-addon/asuswrt/usr/sbin/*" \
           "$HOME/blackfuel/asuswrt-merlin-addon/asuswrt/usr/lib/*"
set -x

# update the staging area
rsync -avh --existing --delete-after $HOME/blackfuel/asuswrt-merlin-addon/asuswrt/* $HOME/blackfuel/asuswrt-merlin-addon/staging
cp -a $HOME/blackfuel/asuswrt-merlin-addon/staging/native/sbin $HOME/blackfuel/asuswrt-merlin-addon/staging


