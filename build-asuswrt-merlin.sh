#!/bin/bash
make_clean() {
  make clean
  rm -f ${HOME}/asuswrt-merlin/release/src/router/rc/prebuild/*.o
  rm -f ${HOME}/asuswrt-merlin/release/src/router/shared/prebuild/*.o
  rm .config
}

update_package() {
  local name="$1"
  local mypackage="../../../../asuswrt-merlin-${name}/"
  if [ "$(readlink ${name})" != "${mypackage}" ]; then
    [ -e ${name} ] && mv -f ${name} ${name}-asus
    ln -sf ${mypackage} ${name}
  fi
}

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
make ${BUILD_MODEL_2}
pushd .
cd image
[ -d "${BUILD_MODEL}" ] && rm -rf "${BUILD_MODEL}"
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
make_clean

#---

BUILD_MODEL="RT-AC56U"
BUILD_MODEL_2="rt-ac56u"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/src-rt-6.x.4708"
cd ${HOME}/asuswrt-merlin/release/src/router
update_package tor
update_package nettle
cd ${BUILD_FOLDER}
make_clean
make ${BUILD_MODEL_2}
pushd .
cd image
[ -d "${BUILD_MODEL}" ] && rm -rf "${BUILD_MODEL}"
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
make_clean

#---

BUILD_MODEL="RT-AC88U"
BUILD_MODEL_2="rt-ac88u"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/src-rt-7.14.114.x/src"
cd ${HOME}/asuswrt-merlin/release/src/router
update_package tor
update_package nettle
cd ${BUILD_FOLDER}
make_clean
make ${BUILD_MODEL_2}
pushd .
cd image
[ -d "${BUILD_MODEL}" ] && rm -rf "${BUILD_MODEL}"
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
make_clean

#---

BUILD_MODEL="RT-AC3100"
BUILD_MODEL_2="rt-ac3100"
BUILD_FOLDER="${HOME}/asuswrt-merlin/release/src-rt-7.14.114.x/src"
cd ${HOME}/asuswrt-merlin/release/src/router
update_package tor
update_package nettle
cd ${BUILD_FOLDER}
make_clean
make ${BUILD_MODEL_2}
pushd .
cd image
[ -d "${BUILD_MODEL}" ] && rm -rf "${BUILD_MODEL}"
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
make_clean

#---
$HOME/blackfuel/asuswrt-merlin-tools/install detach
$HOME/blackfuel/asuswrt-merlin-tools/cp detach
