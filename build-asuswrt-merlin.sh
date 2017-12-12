#!/bin/bash
make_clean() {
  make clean
  rm -f ${HOME}/asuswrt-merlin/release/src/router/rc/prebuild/*.o
  rm -f ${HOME}/asuswrt-merlin/release/src/router/shared/prebuild/*.o
  rm -f .config
  rm -rf image/${BUILD_MODEL}
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

SANDBOX="/mnt/hgfs/sandbox"
if [ -d "$SANDBOX" ]; then
  DST="$SANDBOX/__blackfuel_release_new"
#######################  rm -rf $DST
  mkdir -p $DST
else
  exit 1  
fi

#---

BUILD_MODEL="RT-AC68U"
BUILD_MODEL_2="rt-ac68u"
SDK_FOLDER="src-rt-6.x.4708"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/$SDK_FOLDER"
if [ ! -d "$DST/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin/release/src/router
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
cat sha256sum.txt >>"${DST}/sha256sums.txt"
mv sha256sum.txt ${BUILD_MODEL}
mv -vf ${BUILD_MODEL} ${DST}/
cd ${BUILD_FOLDER}
#make_clean
fi

#---

BUILD_MODEL="RT-AC56U"
BUILD_MODEL_2="rt-ac56u"
SDK_FOLDER="src-rt-6.x.4708"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/$SDK_FOLDER"
if [ ! -d "$DST/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin/release/src/router
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
cat sha256sum.txt >>"${DST}/sha256sums.txt"
mv sha256sum.txt ${BUILD_MODEL}
mv -vf ${BUILD_MODEL} ${DST}/
cd ${BUILD_FOLDER}
#make_clean
fi

#---

BUILD_MODEL="RT-AC88U"
BUILD_MODEL_2="rt-ac88u"
SDK_FOLDER="src-rt-7.14.114.x/src"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/$SDK_FOLDER"
if [ ! -d "$DST/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin/release/src/router
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
cat sha256sum.txt >>"${DST}/sha256sums.txt"
mv sha256sum.txt ${BUILD_MODEL}
mv -vf ${BUILD_MODEL} ${DST}/
cd ${BUILD_FOLDER}
#make_clean
fi

#---

BUILD_MODEL="RT-AC3100"
BUILD_MODEL_2="rt-ac3100"
SDK_FOLDER="src-rt-7.14.114.x/src"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/$SDK_FOLDER"
if [ ! -d "$DST/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin/release/src/router
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
cat sha256sum.txt >>"${DST}/sha256sums.txt"
mv sha256sum.txt ${BUILD_MODEL}
mv -vf ${BUILD_MODEL} ${DST}/
cd ${BUILD_FOLDER}
#make_clean
fi

#---

BUILD_MODEL="RT-AC5300"
BUILD_MODEL_2="rt-ac5300"
SDK_FOLDER="src-rt-7.14.114.x/src"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/$SDK_FOLDER"
if [ ! -d "$DST/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin/release/src/router
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
cat sha256sum.txt >>"${DST}/sha256sums.txt"
mv sha256sum.txt ${BUILD_MODEL}
mv -vf ${BUILD_MODEL} ${DST}/
cd ${BUILD_FOLDER}
#make_clean
fi

#---

BUILD_MODEL="RT-AC87U"
BUILD_MODEL_2="rt-ac87u"
SDK_FOLDER="src-rt-6.x.4708"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/$SDK_FOLDER"
if [ ! -d "$DST/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin/release/src/router
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
cat sha256sum.txt >>"${DST}/sha256sums.txt"
mv sha256sum.txt ${BUILD_MODEL}
mv -vf ${BUILD_MODEL} ${DST}/
cd ${BUILD_FOLDER}
#make_clean
fi

#---

BUILD_MODEL="RT-AC3200"
BUILD_MODEL_2="rt-ac3200"
SDK_FOLDER="src-rt-7.x.main/src"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/$SDK_FOLDER"
if [ ! -d "$DST/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin/release/src/router
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
cat sha256sum.txt >>"${DST}/sha256sums.txt"
mv sha256sum.txt ${BUILD_MODEL}
mv -vf ${BUILD_MODEL} ${DST}/
cd ${BUILD_FOLDER}
#make_clean
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
echo "\`Tor 0.3.1.9, NTP 4.2.8p10, DNSCrypt 1.9.5, Curl 7.57.0, Wget 1.19.2, Cryptsetup 1.7.5, Wipe 2.3.1, Whois 5.2.18, Findutils 4.6.0, Apcupsd 3.14.14, Powstatd 1.5.1, Haveged 1.9.1, Rngtools 5, Rtl-entropy, RTL-SDR, Dieharder 3.31.1\`" >>"$NOTES"
echo >>"$NOTES"

#---
$HOME/blackfuel/asuswrt-merlin-tools/install detach
$HOME/blackfuel/asuswrt-merlin-tools/cp detach

