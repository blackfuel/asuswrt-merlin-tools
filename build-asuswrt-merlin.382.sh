#!/bin/bash
get_version_info() {
	VERSION_CONF=$(cat $HOME/asuswrt-merlin.382/release/src-rt/version.conf)
	eval $(/bin/echo $VERSION_CONF | /bin/sed 's# #\n#g' | grep SERIALNO)
	eval $(/bin/echo $VERSION_CONF | /bin/sed 's# #\n#g' | grep EXTENDNO)
	BUILD_VER="${SERIALNO}_${EXTENDNO}"
	BUILD_VER2="${SERIALNO}-${EXTENDNO}"
}

make_clean() {
	make clean
	rm -f ${HOME}/asuswrt-merlin.382/release/src/router/rc/prebuild/*.o
	rm -f ${HOME}/asuswrt-merlin.382/release/src/router/shared/prebuild/*.o
	rm -f .config
	rm -rf image/${BUILD_MODEL}

	get_version_info
}

make_clean_2() {
	cd $HOME/blackfuel
	rm -rf asuswrt-merlin.382
	tar xzvf /mnt/hgfs/sandbox/384.3-alpha2-13bf17a.tar.gz
	mv asuswrt-merlin.ng-master asuswrt-merlin.382
#	mv asuswrt-merlin.382-master asuswrt-merlin.382
	get_version_info
	rm -rf ~/asuswrt-merlin.382/release/src-rt-6.x.4708/toolchains
	ln -s ~/am-toolchains/brcm-arm-sdk ~/asuswrt-merlin.382/release/src-rt-6.x.4708/toolchains
	rm -rf ~/asuswrt-merlin.382/tools
	ln -s ~/am-toolchains/brcm-mips-sdk/tools ~/asuswrt-merlin.382/tools
	cd asuswrt-merlin.382
	patch -p1 -i $HOME/blackfuel/asuswrt-merlin-tools/384.3_alpha2_X-ARM-mods+apps+xtables-addons.patch
}

make_clean_3() {
	cd $HOME/blackfuel
	rm -rf asuswrt-merlin.382
	tar xzvf /mnt/hgfs/sandbox/384.3-alpha2-13bf17a.tar.gz
	mv asuswrt-merlin.ng-master asuswrt-merlin.382
#	mv asuswrt-merlin.382-master asuswrt-merlin.382
	get_version_info
	rm -rf ~/asuswrt-merlin.382/release/src-rt-6.x.4708/toolchains
	ln -s ~/am-toolchains/brcm-arm-sdk ~/asuswrt-merlin.382/release/src-rt-6.x.4708/toolchains
	rm -rf ~/asuswrt-merlin.382/tools
	ln -s ~/am-toolchains/brcm-mips-sdk/tools ~/asuswrt-merlin.382/tools
	cd asuswrt-merlin.382
	patch -p1 -i $HOME/blackfuel/asuswrt-merlin-tools/384.3_alpha2_X-ARM-mods+apps+xtables-addons+nofiles.patch
	ed -s < ~/blackfuel/asuswrt-merlin-tools/asuswrt-merlin-target.patch

#	cp -p $HOME/blackfuel/asuswrt-merlin.382-blackfuel/release/src/router/busybox-1.24.1/busybox-1.24.1/config_base release/src/router/busybox-1.24.1/busybox-1.24.1/
#	cp -p $HOME/blackfuel/asuswrt-merlin.382-blackfuel/release/src/router/config/config.in release/src/router/config/
#	cp -p $HOME/blackfuel/asuswrt-merlin.382-blackfuel/release/src/router/Makefile release/src/router/
#	cp -p $HOME/blackfuel/asuswrt-merlin.382-blackfuel/release/src-rt/Makefile release/src-rt/
#	cp -p $HOME/blackfuel/asuswrt-merlin.382-blackfuel/release/src/router/rc/Makefile release/src/router/rc/
#	cp -p $HOME/blackfuel/asuswrt-merlin.382-blackfuel/release/src/router/rc/rc.c release/src/router/rc/
#	cp -p $HOME/blackfuel/asuswrt-merlin.382-blackfuel/release/src/router/rc/init.c release/src/router/rc/
#	cp -p $HOME/blackfuel/asuswrt-merlin.382-blackfuel/release/src/router/rc/watchdog.c release/src/router/rc/
#	cp -p $HOME/blackfuel/asuswrt-merlin.382-blackfuel/release/src/router/shared/shared.h release/src/router/shared/
#	cp -p $HOME/blackfuel/asuswrt-merlin.382-blackfuel/release/src/router/shared/scripts.c release/src/router/shared/
#	cp -p $HOME/blackfuel/asuswrt-merlin.382-blackfuel/release/src/router/httpd/web.c release/src/router/httpd/
#	cp -p $HOME/blackfuel/asuswrt-merlin.382-blackfuel/release/src/router/httpd/httpd.c release/src/router/httpd/
#	cp -p $HOME/blackfuel/asuswrt-merlin.382-blackfuel/release/src/router/httpd/httpd.h release/src/router/httpd/
#	cp -p $HOME/blackfuel/asuswrt-merlin.382-blackfuel/release/src-rt-5.02hnd/kernel/linux-4.1/config_base.6a release/src-rt-5.02hnd/kernel/linux-4.1/

	$HOME/blackfuel/asuswrt-merlin-tools/merlin-diff.382.sh
	mv -f $HOME/merlin-diff.patch $HOME/${BUILD_VER}_X-ARM-mods+apps+xtables-addons+nofiles.patch

	cp -a $HOME/blackfuel/asuswrt-merlin-xtables-addons-1.47.1/release ./
	patch -p1 -i $HOME/blackfuel/asuswrt-merlin-tools/asuswrt-arm-entropy-backport-3.16.43_382.patch

	$HOME/blackfuel/asuswrt-merlin-tools/merlin-diff.382.sh
	mv -f $HOME/merlin-diff.patch $HOME/${BUILD_VER}_X-ARM-mods+apps+xtables-addons.patch
}

set -e
set -x

### setup toolchains

export ORIG_PATH="$PATH"

[ ! -d /opt ] && sudo mkdir -p /opt

if [ ! -d ~/am-toolchains ]; then
  cd
  git clone https://github.com/blackfuel/am-toolchains.git
fi

sudo rm -rf /opt/toolchains
sudo ln -s ~/am-toolchains/brcm-arm-hnd /opt/toolchains

sudo rm -f /opt/brcm-arm
sudo ln -s ~/am-toolchains/brcm-arm-sdk/hndtools-arm-linux-2.6.36-uclibc-4.5.3 /opt/brcm-arm

sudo rm -f /opt/brcm
sudo ln -s ~/am-toolchains/brcm-mips-sdk/tools/brcm /opt/brcm

[ ! -h /opt/brcm ] && sudo ln -sf $HOME/asuswrt-merlin/tools/brcm /opt/brcm

if [ -d ~/asuswrt-merlin.382 ]; then
  rm -rf ~/asuswrt-merlin.382/release/src-rt-5.02hnd/bcmdrivers/broadcom/net/wl/impl51/main/src/toolchains
  ln -s ~/am-toolchains/brcm-arm-hnd ~/asuswrt-merlin.382/release/src-rt-5.02hnd/bcmdrivers/broadcom/net/wl/impl51/main/src/toolchains

  rm -rf ~/asuswrt-merlin.382/release/src-rt-6.x.4708/toolchains
  ln -s ~/am-toolchains/brcm-arm-sdk ~/asuswrt-merlin.382/release/src-rt-6.x.4708/toolchains

  rm -rf ~/asuswrt-merlin.382/tools
  ln -s ~/am-toolchains/brcm-mips-sdk/tools ~/asuswrt-merlin.382/tools
fi

if [ -d ~/asuswrt-merlin ]; then
  rm -rf ~/asuswrt-merlin/release/src-rt-6.x.4708/toolchains
  ln -s ~/am-toolchains/brcm-arm-sdk ~/asuswrt-merlin/release/src-rt-6.x.4708/toolchains

  rm -rf ~/asuswrt-merlin/tools
  ln -s ~/am-toolchains/brcm-mips-sdk/tools ~/asuswrt-merlin/tools
fi

sudo mkdir -p /projects/hnd/tools/linux
sudo rm -rf /projects/hnd/tools/linux/hndtools-armeabi-2011.09
sudo ln -s ~/am-toolchains/brcm-arm-sdk/hndtools-armeabi-2011.09 /projects/hnd/tools/linux/hndtools-armeabi-2011.09
sudo rm -rf /projects/hnd/tools/linux/hndtools-armeabi-2013.11
sudo ln -s ~/am-toolchains/brcm-arm-sdk/hndtools-armeabi-2013.11 /projects/hnd/tools/linux/hndtools-armeabi-2013.11
sudo rm -rf /projects/hnd/tools/linux/hndtools-arm-linux-2.6.36-uclibc-4.5.3
sudo ln -s ~/am-toolchains/brcm-arm-sdk/hndtools-arm-linux-2.6.36-uclibc-4.5.3 /projects/hnd/tools/linux/hndtools-arm-linux-2.6.36-uclibc-4.5.3

sudo rm -rf /bin/sh
sudo ln -s bash /bin/sh
#sudo ln -s dash /bin/sh

###

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

#BUILD_SDK="ARM"
BUILD_SDK="HND"

#---

if [ "$BUILD_SDK" == "ARM" ]; then

make_clean_3

export PATH="$ORIG_PATH"
export LD_LIBRARY_PATH=
export TOOLCHAIN_BASE=
echo $PATH | grep -qF /opt/brcm-arm/bin || export PATH=$PATH:/opt/brcm-arm/bin
echo $PATH | grep -qF /opt/brcm-arm/arm-brcm-linux-uclibcgnueabi/bin || export PATH=$PATH:/opt/brcm-arm/arm-brcm-linux-uclibcgnueabi/bin
echo $PATH | grep -qF /opt/brcm/hndtools-mipsel-linux/bin || export PATH=$PATH:/opt/brcm/hndtools-mipsel-linux/bin
echo $PATH | grep -qF /opt/brcm/hndtools-mipsel-uclibc/bin || export PATH=$PATH:/opt/brcm/hndtools-mipsel-uclibc/bin

BUILD_MODEL="RT-AC68U"
BUILD_MODEL_2="rt-ac68u"
SDK_FOLDER="src-rt-6.x.4708"
BUILD_FOLDER="${HOME}/asuswrt-merlin.382/release/$SDK_FOLDER"
if [ ! -d "$DST/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin.382/release/src/router
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

make_clean_3

export PATH="$ORIG_PATH"
export LD_LIBRARY_PATH=
export TOOLCHAIN_BASE=
echo $PATH | grep -qF /opt/brcm-arm/bin || export PATH=$PATH:/opt/brcm-arm/bin
echo $PATH | grep -qF /opt/brcm-arm/arm-brcm-linux-uclibcgnueabi/bin || export PATH=$PATH:/opt/brcm-arm/arm-brcm-linux-uclibcgnueabi/bin
echo $PATH | grep -qF /opt/brcm/hndtools-mipsel-linux/bin || export PATH=$PATH:/opt/brcm/hndtools-mipsel-linux/bin
echo $PATH | grep -qF /opt/brcm/hndtools-mipsel-uclibc/bin || export PATH=$PATH:/opt/brcm/hndtools-mipsel-uclibc/bin

BUILD_MODEL="RT-AC56U"
BUILD_MODEL_2="rt-ac56u"
SDK_FOLDER="src-rt-6.x.4708"
BUILD_FOLDER="${HOME}/asuswrt-merlin.382/release/$SDK_FOLDER"
if [ ! -d "$DST/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin.382/release/src/router
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

make_clean_3

export PATH="$ORIG_PATH"
export LD_LIBRARY_PATH=
export TOOLCHAIN_BASE=
echo $PATH | grep -qF /opt/brcm-arm/bin || export PATH=$PATH:/opt/brcm-arm/bin
echo $PATH | grep -qF /opt/brcm-arm/arm-brcm-linux-uclibcgnueabi/bin || export PATH=$PATH:/opt/brcm-arm/arm-brcm-linux-uclibcgnueabi/bin
echo $PATH | grep -qF /opt/brcm/hndtools-mipsel-linux/bin || export PATH=$PATH:/opt/brcm/hndtools-mipsel-linux/bin
echo $PATH | grep -qF /opt/brcm/hndtools-mipsel-uclibc/bin || export PATH=$PATH:/opt/brcm/hndtools-mipsel-uclibc/bin

BUILD_MODEL="RT-AC88U"
BUILD_MODEL_2="rt-ac88u"
SDK_FOLDER="src-rt-7.14.114.x/src"
BUILD_FOLDER="${HOME}/asuswrt-merlin.382/release/$SDK_FOLDER"
if [ ! -d "$DST/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin.382/release/src/router
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

make_clean_3

export PATH="$ORIG_PATH"
export LD_LIBRARY_PATH=
export TOOLCHAIN_BASE=
echo $PATH | grep -qF /opt/brcm-arm/bin || export PATH=$PATH:/opt/brcm-arm/bin
echo $PATH | grep -qF /opt/brcm-arm/arm-brcm-linux-uclibcgnueabi/bin || export PATH=$PATH:/opt/brcm-arm/arm-brcm-linux-uclibcgnueabi/bin
echo $PATH | grep -qF /opt/brcm/hndtools-mipsel-linux/bin || export PATH=$PATH:/opt/brcm/hndtools-mipsel-linux/bin
echo $PATH | grep -qF /opt/brcm/hndtools-mipsel-uclibc/bin || export PATH=$PATH:/opt/brcm/hndtools-mipsel-uclibc/bin

BUILD_MODEL="RT-AC3100"
BUILD_MODEL_2="rt-ac3100"
SDK_FOLDER="src-rt-7.14.114.x/src"
BUILD_FOLDER="${HOME}/asuswrt-merlin.382/release/$SDK_FOLDER"
if [ ! -d "$DST/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin.382/release/src/router
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

fi

#---

if [ "$BUILD_SDK" == "HND" ]; then

export PATH="$ORIG_PATH"
export LD_LIBRARY_PATH=/opt/toolchains/crosstools-arm-gcc-5.3-linux-4.1-glibc-2.22-binutils-2.25/usr/lib
export TOOLCHAIN_BASE=/opt/toolchains
echo $PATH | grep -qF /opt/toolchains/crosstools-arm-gcc-5.3-linux-4.1-glibc-2.22-binutils-2.25/usr/bin || export PATH=$PATH:/opt/toolchains/crosstools-arm-gcc-5.3-linux-4.1-glibc-2.22-binutils-2.25/usr/bin
echo $PATH | grep -qF /opt/toolchains/crosstools-aarch64-gcc-5.3-linux-4.1-glibc-2.22-binutils-2.25/usr/bin || export PATH=$PATH:/opt/toolchains/crosstools-aarch64-gcc-5.3-linux-4.1-glibc-2.22-binutils-2.25/usr/bin

make_clean_3

BUILD_MODEL="RT-AC86U"
BUILD_MODEL_2="rt-ac86u"
SDK_FOLDER="src-rt-5.02hnd"
BUILD_FOLDER="${HOME}/asuswrt-merlin.382/release/$SDK_FOLDER"
if [ ! -d "$DST/$BUILD_MODEL" ]; then
cd ${HOME}/asuswrt-merlin.382/release/src/router
cd ${BUILD_FOLDER}
#make_clean
make ${BUILD_MODEL_2}
tar czvf ${BUILD_MODEL}_${BUILD_VER}_image.tar.gz -C targets 94908HND
cd targets/94908HND
mkdir -p ${BUILD_MODEL}
mv ../../${BUILD_MODEL}_${BUILD_VER}_image.tar.gz ${BUILD_MODEL}
sha256sum ${BUILD_MODEL}_${BUILD_VER}_cferom_ubi.w > sha256sum.txt
zip ${BUILD_MODEL}_${BUILD_VER}_blackfuel.zip ${BUILD_MODEL}_${BUILD_VER}_cferom_ubi.w sha256sum.txt
mv ${BUILD_MODEL}_${BUILD_VER}_cferom_ubi.w ${BUILD_MODEL}
mv ${BUILD_MODEL}_${BUILD_VER}_blackfuel.zip ${BUILD_MODEL}
cat sha256sum.txt >>"${DST}/sha256sums.txt"
mv sha256sum.txt ${BUILD_MODEL}
mv -vf ${BUILD_MODEL} ${DST}/
cd ${BUILD_FOLDER}
fi

fi

#---

# create release notes

if [ "$BUILD_SDK" == "ARM" ]; then
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
echo "\`Tor 0.3.2.9, NTP 4.2.8p10, DNSCrypt 1.9.5, Curl 7.58.0, Wget 1.19.4, Cryptsetup 2.0.1, Wipe 2.3.1, Whois 5.3.0, Findutils 4.6.0, Apcupsd 3.14.14, Powstatd 1.5.1, Haveged 1.9.1, Rngtools 5, Rtl-entropy, RTL-SDR, Dieharder 3.31.1\`" >>"$NOTES"
echo >>"$NOTES"
fi

#---
$HOME/blackfuel/asuswrt-merlin-tools/install detach
$HOME/blackfuel/asuswrt-merlin-tools/cp detach

