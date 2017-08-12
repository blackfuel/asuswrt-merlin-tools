#!/bin/bash
make_clean() {
  make clean
  rm -f ${HOME}/asuswrt-merlin/release/src/router/rc/prebuild/*.o
  rm -f ${HOME}/asuswrt-merlin/release/src/router/shared/prebuild/*.o
  rm -f .config
  rm -rf image/${BUILD_MODEL}
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
# sudo apt-get install makedepends libltdl-dev automake1.11

VERSION_CONF=$(cat $HOME/asuswrt-merlin/release/src-rt/version.conf)
eval $(/bin/echo $VERSION_CONF | /bin/sed 's# #\n#g' | grep SERIALNO)
eval $(/bin/echo $VERSION_CONF | /bin/sed 's# #\n#g' | grep EXTENDNO)
BUILD_VER="${SERIALNO}_${EXTENDNO}"
BUILD_VER2="${SERIALNO}-${EXTENDNO}"
$HOME/blackfuel/asuswrt-merlin-tools/install attach
$HOME/blackfuel/asuswrt-merlin-tools/cp attach
chmod -R a+rwx /opt/brcm-arm/bin

#---

BUILD_MODEL="RT-AC68U"
BUILD_MODEL_2="rt-ac68u"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/src-rt-6.x.4708"
if [ ! -d "$BUILD_FOLDER/image/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin/release/src/router
update_package tor
update_package nettle
cd ${BUILD_FOLDER}
make_clean
make ${BUILD_MODEL_2}
pushd .
cd image
mkdir -p ${BUILD_MODEL}/router
mkdir -p ${BUILD_MODEL}/linux/linux-2.6.36
cp -p ../.config ${BUILD_MODEL}
cp -p ../router/config_${BUILD_MODEL_2} ${BUILD_MODEL}/router
cp -p ../linux/linux-2.6.36/config_${BUILD_MODEL_2} ${BUILD_MODEL}/linux/linux-2.6.36
cp -p ../linux/linux-2.6.36/Module.symvers ${BUILD_MODEL}/linux/linux-2.6.36
pushd .
cd ${PWD%%/release*}/release/src/router
tar czvf ${BUILD_FOLDER}/image/${BUILD_MODEL}/${BUILD_MODEL}_${BUILD_VER}_modules-netfilter.tar.gz arm-uclibc/target/lib/modules/2.6.36.4brcmarm/kernel/net/netfilter
tar czvf ${BUILD_FOLDER}/image/${BUILD_MODEL}/${BUILD_MODEL}_${BUILD_VER}_modules-extras.tar.gz arm-uclibc/extras
popd
mv ${BUILD_MODEL}_${BUILD_VER}.trx ${BUILD_MODEL}_${BUILD_VER}_blackfuel.trx
sha256sum *.trx > sha256sum.txt
zip ${BUILD_MODEL}_${BUILD_VER}_blackfuel.zip *.trx sha256sum.txt
mv *.trx ${BUILD_MODEL}
mv *.zip ${BUILD_MODEL}
mv sha256sum.txt ${BUILD_MODEL}
cd ${BUILD_FOLDER}
#make_clean
fi

#---

BUILD_MODEL="RT-AC56U"
BUILD_MODEL_2="rt-ac56u"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/src-rt-6.x.4708"
if [ ! -d "$BUILD_FOLDER/image/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin/release/src/router
update_package tor
update_package nettle
cd ${BUILD_FOLDER}
make_clean
make ${BUILD_MODEL_2}
pushd .
cd image
mkdir -p ${BUILD_MODEL}/router
mkdir -p ${BUILD_MODEL}/linux/linux-2.6.36
cp -p ../.config ${BUILD_MODEL}
cp -p ../router/config_${BUILD_MODEL_2} ${BUILD_MODEL}/router
cp -p ../linux/linux-2.6.36/config_${BUILD_MODEL_2} ${BUILD_MODEL}/linux/linux-2.6.36
cp -p ../linux/linux-2.6.36/Module.symvers ${BUILD_MODEL}/linux/linux-2.6.36
pushd .
cd ${PWD%%/release*}/release/src/router
tar czvf ${BUILD_FOLDER}/image/${BUILD_MODEL}/${BUILD_MODEL}_${BUILD_VER}_modules-netfilter.tar.gz arm-uclibc/target/lib/modules/2.6.36.4brcmarm/kernel/net/netfilter
tar czvf ${BUILD_FOLDER}/image/${BUILD_MODEL}/${BUILD_MODEL}_${BUILD_VER}_modules-extras.tar.gz arm-uclibc/extras
popd
mv ${BUILD_MODEL}_${BUILD_VER}.trx ${BUILD_MODEL}_${BUILD_VER}_blackfuel.trx
sha256sum *.trx > sha256sum.txt
zip ${BUILD_MODEL}_${BUILD_VER}_blackfuel.zip *.trx sha256sum.txt
mv *.trx ${BUILD_MODEL}
mv *.zip ${BUILD_MODEL}
mv sha256sum.txt ${BUILD_MODEL}
cd ${BUILD_FOLDER}
#make_clean
fi

#---

BUILD_MODEL="RT-AC88U"
BUILD_MODEL_2="rt-ac88u"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/src-rt-7.14.114.x/src"
if [ ! -d "$BUILD_FOLDER/image/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin/release/src/router
update_package tor
update_package nettle
cd ${BUILD_FOLDER}
make_clean
make ${BUILD_MODEL_2}
pushd .
cd image
mkdir -p ${BUILD_MODEL}/router
mkdir -p ${BUILD_MODEL}/linux/linux-2.6.36
cp -p ../.config ${BUILD_MODEL}
cp -p ../router/config_${BUILD_MODEL_2} ${BUILD_MODEL}/router
cp -p ../linux/linux-2.6.36/config_${BUILD_MODEL_2} ${BUILD_MODEL}/linux/linux-2.6.36
cp -p ../linux/linux-2.6.36/Module.symvers ${BUILD_MODEL}/linux/linux-2.6.36
pushd .
cd ${PWD%%/release*}/release/src/router
tar czvf ${BUILD_FOLDER}/image/${BUILD_MODEL}/${BUILD_MODEL}_${BUILD_VER}_modules-netfilter.tar.gz arm-uclibc/target/lib/modules/2.6.36.4brcmarm/kernel/net/netfilter
tar czvf ${BUILD_FOLDER}/image/${BUILD_MODEL}/${BUILD_MODEL}_${BUILD_VER}_modules-extras.tar.gz arm-uclibc/extras
popd
mv ${BUILD_MODEL}_${BUILD_VER}.trx ${BUILD_MODEL}_${BUILD_VER}_blackfuel.trx
sha256sum *.trx > sha256sum.txt
zip ${BUILD_MODEL}_${BUILD_VER}_blackfuel.zip *.trx sha256sum.txt
mv *.trx ${BUILD_MODEL}
mv *.zip ${BUILD_MODEL}
mv sha256sum.txt ${BUILD_MODEL}
cd ${BUILD_FOLDER}
#make_clean
fi

#---

BUILD_MODEL="RT-AC3100"
BUILD_MODEL_2="rt-ac3100"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/src-rt-7.14.114.x/src"
if [ ! -d "$BUILD_FOLDER/image/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin/release/src/router
update_package tor
update_package nettle
cd ${BUILD_FOLDER}
make_clean
make ${BUILD_MODEL_2}
pushd .
cd image
mkdir -p ${BUILD_MODEL}/router
mkdir -p ${BUILD_MODEL}/linux/linux-2.6.36
cp -p ../.config ${BUILD_MODEL}
cp -p ../router/config_${BUILD_MODEL_2} ${BUILD_MODEL}/router
cp -p ../linux/linux-2.6.36/config_${BUILD_MODEL_2} ${BUILD_MODEL}/linux/linux-2.6.36
cp -p ../linux/linux-2.6.36/Module.symvers ${BUILD_MODEL}/linux/linux-2.6.36
pushd .
cd ${PWD%%/release*}/release/src/router
tar czvf ${BUILD_FOLDER}/image/${BUILD_MODEL}/${BUILD_MODEL}_${BUILD_VER}_modules-netfilter.tar.gz arm-uclibc/target/lib/modules/2.6.36.4brcmarm/kernel/net/netfilter
tar czvf ${BUILD_FOLDER}/image/${BUILD_MODEL}/${BUILD_MODEL}_${BUILD_VER}_modules-extras.tar.gz arm-uclibc/extras
popd
mv ${BUILD_MODEL}_${BUILD_VER}.trx ${BUILD_MODEL}_${BUILD_VER}_blackfuel.trx
sha256sum *.trx > sha256sum.txt
zip ${BUILD_MODEL}_${BUILD_VER}_blackfuel.zip *.trx sha256sum.txt
mv *.trx ${BUILD_MODEL}
mv *.zip ${BUILD_MODEL}
mv sha256sum.txt ${BUILD_MODEL}
cd ${BUILD_FOLDER}
#make_clean
fi

#---

BUILD_MODEL="RT-AC5300"
BUILD_MODEL_2="rt-ac5300"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/src-rt-7.14.114.x/src"
if [ ! -d "$BUILD_FOLDER/image/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin/release/src/router
update_package tor
update_package nettle
cd ${BUILD_FOLDER}
make_clean
make ${BUILD_MODEL_2}
pushd .
cd image
mkdir -p ${BUILD_MODEL}/router
mkdir -p ${BUILD_MODEL}/linux/linux-2.6.36
cp -p ../.config ${BUILD_MODEL}
cp -p ../router/config_${BUILD_MODEL_2} ${BUILD_MODEL}/router
cp -p ../linux/linux-2.6.36/config_${BUILD_MODEL_2} ${BUILD_MODEL}/linux/linux-2.6.36
cp -p ../linux/linux-2.6.36/Module.symvers ${BUILD_MODEL}/linux/linux-2.6.36
pushd .
cd ${PWD%%/release*}/release/src/router
tar czvf ${BUILD_FOLDER}/image/${BUILD_MODEL}/${BUILD_MODEL}_${BUILD_VER}_modules-netfilter.tar.gz arm-uclibc/target/lib/modules/2.6.36.4brcmarm/kernel/net/netfilter
tar czvf ${BUILD_FOLDER}/image/${BUILD_MODEL}/${BUILD_MODEL}_${BUILD_VER}_modules-extras.tar.gz arm-uclibc/extras
popd
mv ${BUILD_MODEL}_${BUILD_VER}.trx ${BUILD_MODEL}_${BUILD_VER}_blackfuel.trx
sha256sum *.trx > sha256sum.txt
zip ${BUILD_MODEL}_${BUILD_VER}_blackfuel.zip *.trx sha256sum.txt
mv *.trx ${BUILD_MODEL}
mv *.zip ${BUILD_MODEL}
mv sha256sum.txt ${BUILD_MODEL}
cd ${BUILD_FOLDER}
#make_clean
fi

#---

BUILD_MODEL="RT-AC87U"
BUILD_MODEL_2="rt-ac87u"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/src-rt-6.x.4708"
if [ ! -d "$BUILD_FOLDER/image/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin/release/src/router
update_package tor
update_package nettle
cd ${BUILD_FOLDER}
make_clean
make ${BUILD_MODEL_2}
pushd .
cd image
mkdir -p ${BUILD_MODEL}/router
mkdir -p ${BUILD_MODEL}/linux/linux-2.6.36
cp -p ../.config ${BUILD_MODEL}
cp -p ../router/config_${BUILD_MODEL_2} ${BUILD_MODEL}/router
cp -p ../linux/linux-2.6.36/config_${BUILD_MODEL_2} ${BUILD_MODEL}/linux/linux-2.6.36
cp -p ../linux/linux-2.6.36/Module.symvers ${BUILD_MODEL}/linux/linux-2.6.36
pushd .
cd ${PWD%%/release*}/release/src/router
tar czvf ${BUILD_FOLDER}/image/${BUILD_MODEL}/${BUILD_MODEL}_${BUILD_VER}_modules-netfilter.tar.gz arm-uclibc/target/lib/modules/2.6.36.4brcmarm/kernel/net/netfilter
tar czvf ${BUILD_FOLDER}/image/${BUILD_MODEL}/${BUILD_MODEL}_${BUILD_VER}_modules-extras.tar.gz arm-uclibc/extras
popd
mv ${BUILD_MODEL}_${BUILD_VER}.trx ${BUILD_MODEL}_${BUILD_VER}_blackfuel.trx
sha256sum *.trx > sha256sum.txt
zip ${BUILD_MODEL}_${BUILD_VER}_blackfuel.zip *.trx sha256sum.txt
mv *.trx ${BUILD_MODEL}
mv *.zip ${BUILD_MODEL}
mv sha256sum.txt ${BUILD_MODEL}
cd ${BUILD_FOLDER}
#make_clean
fi

#---

BUILD_MODEL="RT-AC3200"
BUILD_MODEL_2="rt-ac3200"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/src-rt-7.x.main/src"
if [ ! -d "$BUILD_FOLDER/image/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin/release/src/router
update_package tor
update_package nettle
cd ${BUILD_FOLDER}
make_clean
make ${BUILD_MODEL_2}
pushd .
cd image
mkdir -p ${BUILD_MODEL}/router
mkdir -p ${BUILD_MODEL}/linux/linux-2.6.36
cp -p ../.config ${BUILD_MODEL}
cp -p ../router/config_${BUILD_MODEL_2} ${BUILD_MODEL}/router
cp -p ../linux/linux-2.6.36/config_${BUILD_MODEL_2} ${BUILD_MODEL}/linux/linux-2.6.36
cp -p ../linux/linux-2.6.36/Module.symvers ${BUILD_MODEL}/linux/linux-2.6.36
pushd .
cd ${PWD%%/release*}/release/src/router
tar czvf ${BUILD_FOLDER}/image/${BUILD_MODEL}/${BUILD_MODEL}_${BUILD_VER}_modules-netfilter.tar.gz arm-uclibc/target/lib/modules/2.6.36.4brcmarm/kernel/net/netfilter
tar czvf ${BUILD_FOLDER}/image/${BUILD_MODEL}/${BUILD_MODEL}_${BUILD_VER}_modules-extras.tar.gz arm-uclibc/extras
popd
mv ${BUILD_MODEL}_${BUILD_VER}.trx ${BUILD_MODEL}_${BUILD_VER}_blackfuel.trx
sha256sum *.trx > sha256sum.txt
zip ${BUILD_MODEL}_${BUILD_VER}_blackfuel.zip *.trx sha256sum.txt
mv *.trx ${BUILD_MODEL}
mv *.zip ${BUILD_MODEL}
mv sha256sum.txt ${BUILD_MODEL}
cd ${BUILD_FOLDER}
#make_clean
fi

#---

# move all releases to new folder

SANDBOX="/mnt/hgfs/sandbox"

if [ -d "$SANDBOX" ]; then
  DST="$SANDBOX/__blackfuel_release_new"
  rm -rf $DST
  mkdir -p $DST

  for KERNEL_FOLDER in "src-rt-6.x.4708" "src-rt-7.14.114.x/src" "src-rt-7.x.main/src"; do
    SRC="$HOME/asuswrt-merlin/release/$KERNEL_FOLDER/image"
    mv -v $SRC/RT-* $DST
  done

  for HASH_FILE in $DST/RT-*/sha256sum.txt; do
    cat "$HASH_FILE" >>"$DST/sha256sums.txt"
  done
fi

#---

# create release notes

NOTES="$DST/blackfuel-release.txt"
echo "=============================================================================================" >>"$NOTES"
echo "$BUILD_VER2" >>"$NOTES"
echo "Asuswrt-Merlin $BUILD_VER2 (Blackfuel)" >>"$NOTES"
echo >>"$NOTES"
echo "__SHA256 signatures__" >>"$NOTES"
echo "\`\`\`" >>"$NOTES"
cat "$DST/sha256sums.txt" >>"$NOTES"
echo "\`\`\`" >>"$NOTES"
echo >>"$NOTES"
echo "__Included in this release__" >>"$NOTES"
echo "\`Tor 0.3.0.10, NTP 4.2.8p10, DNSCrypt 1.9.5, Cryptsetup 1.7.5, Whois 5.2.16\`" >>"$NOTES"
echo "- busybox: stty, base64, sha512sum, sha256sum, sha3sum, sha1sum, uudecode, uuencode, whoami" >>"$NOTES"
echo >>"$NOTES"

#---
$HOME/blackfuel/asuswrt-merlin-tools/install detach
$HOME/blackfuel/asuswrt-merlin-tools/cp detach

