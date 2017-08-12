#!/bin/bash
make_clean() {
  make clean
  rm -f ${HOME}/asuswrt-merlin/release/src/router/rc/prebuild/*.o
  rm -f ${HOME}/asuswrt-merlin/release/src/router/shared/prebuild/*.o
  rm -f .config
}

update_package() {
  local name="$1"
  local mypackage="../../../../asuswrt-merlin-${name}/"
  if [ "$(readlink ${name})" != "${mypackage}" ]; then
    [ -e ${name} ] && mv -f ${name} ${name}-asus
    ln -sf ${mypackage} ${name}
  fi
}

set -e
set -x

[ ! -d /opt ] && sudo mkdir -p /opt
[ ! -h /opt/brcm ] && sudo ln -sf $HOME/asuswrt-merlin/tools/brcm /opt/brcm
[ ! -h /opt/brcm-arm ] && sudo ln -sf $HOME/asuswrt-merlin/release/src-rt-6.x.4708/toolchains/hndtools-arm-linux-2.6.36-uclibc-4.5.3 /opt/brcm-arm
[ ! -d /projects/hnd/tools/linux ] && sudo mkdir -p /projects/hnd/tools/linux
[ ! -h /projects/hnd/tools/linux/hndtools-arm-linux-2.6.36-uclibc-4.5.3 ] && sudo ln -sf /opt/brcm-arm /projects/hnd/tools/linux/hndtools-arm-linux-2.6.36-uclibc-4.5.3
echo $PATH | grep -qF /opt/brcm-arm || export PATH=$PATH:/opt/brcm-arm/bin:/opt/brcm-arm/arm-brcm-linux-uclibcgnueabi/bin:/opt/brcm/hndtools-mipsel-linux/bin:/opt/brcm/hndtools-mipsel-uclibc/bin
# sudo apt-get install xutils-dev libltdl-dev automake1.11

VERSION_CONF=$(cat $HOME/asuswrt-merlin/release/src-rt/version.conf)
eval $(/bin/echo $VERSION_CONF | /bin/sed 's# #\n#g' | grep SERIALNO)
eval $(/bin/echo $VERSION_CONF | /bin/sed 's# #\n#g' | grep EXTENDNO)
BUILD_VER="${SERIALNO}_${EXTENDNO}"
$HOME/blackfuel/asuswrt-merlin-tools/install attach
$HOME/blackfuel/asuswrt-merlin-tools/cp attach
chmod -R a+rwx /opt/brcm-arm/bin
#---
BUILD_MODEL="RT-AC68U"
BUILD_MODEL_2="rt-ac68u"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/src-rt-6.x.4708"
cd ${HOME}/asuswrt-merlin/release/src/router
update_package tor
update_package nettle
cd ${BUILD_FOLDER}
make_clean
make ${BUILD_MODEL_2} CONFIG_DEBUG_SECTION_MISMATCH=y

