#!/bin/bash
MERLIN_TARGET="asuswrt-merlin"
cd
cd ${MERLIN_TARGET}/release/src-rt-6.x.4708
make clean
cd
rm -f merlin-diff.patch
for KERNEL_FOLDER in "src-rt-6.x.4708" "src-rt-7.14.114.x/src" "src-rt-7.x.main/src"; do
  diff -u -B -N ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/config_base.6a ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/config_base.6a >> merlin-diff.patch
  diff -u -B -N ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/drivers/usb/serial/ftdi_sio.c ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/drivers/usb/serial/ftdi_sio.c >> merlin-diff.patch
  diff -u -B -N ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/drivers/usb/serial/generic.c ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/drivers/usb/serial/generic.c >> merlin-diff.patch
  diff -u -B -N -r -x *.rej -x *.orig -x .directory ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/net/netfilter ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/net/netfilter >> merlin-diff.patch

  # squashFS 4K
  diff -u -B -N ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/fs/squashfs/Kconfig ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/fs/squashfs/Kconfig >> merlin-diff.patch
  diff -u -B -N ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/fs/squashfs/squashfs_fs.h ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/fs/squashfs/squashfs_fs.h >> merlin-diff.patch
  diff -u -B -N ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/fs/squashfs/super.c ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/fs/squashfs/super.c >> merlin-diff.patch

  # kernel support for veracrypt
  diff -u -B -N -r ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/crypto/Makefile ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/crypto/Makefile >> merlin-diff.patch
  diff -u -B -N -r ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/crypto/Kconfig ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/crypto/Kconfig >> merlin-diff.patch
  diff -u -B -N -r ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/crypto/af_alg.c ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/crypto/af_alg.c >> merlin-diff.patch
  diff -u -B -N -r ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/crypto/algif_hash.c ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/crypto/algif_hash.c >> merlin-diff.patch
  diff -u -B -N -r ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/crypto/algif_skcipher.c ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/crypto/algif_skcipher.c >> merlin-diff.patch
  diff -u -B -N -r ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/net/core/sock.c ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/net/core/sock.c >> merlin-diff.patch 
  diff -u -B -N -r ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/include/crypto/if_alg.h ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/include/crypto/if_alg.h >> merlin-diff.patch
  diff -u -B -N -r ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/include/crypto/scatterwalk.h ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/include/crypto/scatterwalk.h >> merlin-diff.patch
  diff -u -B -N -r ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/include/linux/if_alg.h ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/include/linux/if_alg.h >> merlin-diff.patch
  diff -u -B -N -r ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/include/linux/socket.h ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/include/linux/socket.h >> merlin-diff.patch

  # entropy backport from 3.16.43
  diff -u -B -N ./${MERLIN_TARGET}-original/release/$KERNEL_FOLDER/linux/linux-2.6.36/include/linux/random.h ./${MERLIN_TARGET}/release/$KERNEL_FOLDER/linux/linux-2.6.36/include/linux/random.h >> merlin-diff.patch
  diff -u -B -N ./${MERLIN_TARGET}-original/release/$KERNEL_FOLDER/linux/linux-2.6.36/drivers/char/random.c ./${MERLIN_TARGET}/release/$KERNEL_FOLDER/linux/linux-2.6.36/drivers/char/random.c >> merlin-diff.patch
  diff -u -B -N ./${MERLIN_TARGET}-original/release/$KERNEL_FOLDER/linux/linux-2.6.36/lib/random32.c ./${MERLIN_TARGET}/release/$KERNEL_FOLDER/linux/linux-2.6.36/lib/random32.c >> merlin-diff.patch
  diff -u -B -N ./${MERLIN_TARGET}-original/release/$KERNEL_FOLDER/linux/linux-2.6.36/include/trace/events/random.h ./${MERLIN_TARGET}/release/$KERNEL_FOLDER/linux/linux-2.6.36/include/trace/events/random.h >> merlin-diff.patch
  diff -u -B -N ./${MERLIN_TARGET}-original/release/$KERNEL_FOLDER/linux/linux-2.6.36/kernel/irq/handle.c ./${MERLIN_TARGET}/release/$KERNEL_FOLDER/linux/linux-2.6.36/kernel/irq/handle.c >> merlin-diff.patch
  diff -u -B -N ./${MERLIN_TARGET}-original/release/$KERNEL_FOLDER/linux/linux-2.6.36/kernel/irq/manage.c ./${MERLIN_TARGET}/release/$KERNEL_FOLDER/linux/linux-2.6.36/kernel/irq/manage.c >> merlin-diff.patch
  diff -u -B -N ./${MERLIN_TARGET}-original/release/$KERNEL_FOLDER/linux/linux-2.6.36/kernel/posix-cpu-timers.c ./${MERLIN_TARGET}/release/$KERNEL_FOLDER/linux/linux-2.6.36/kernel/posix-cpu-timers.c >> merlin-diff.patch
  diff -u -B -N ./${MERLIN_TARGET}-original/release/$KERNEL_FOLDER/linux/linux-2.6.36/drivers/usb/core/hub.c ./${MERLIN_TARGET}/release/$KERNEL_FOLDER/linux/linux-2.6.36/drivers/usb/core/hub.c >> merlin-diff.patch
  diff -u -B -N ./${MERLIN_TARGET}-original/release/$KERNEL_FOLDER/linux/linux-2.6.36/net/core/dev.c ./${MERLIN_TARGET}/release/$KERNEL_FOLDER/linux/linux-2.6.36/net/core/dev.c >> merlin-diff.patch
done

diff -u -B -N -r -x targets4.man -x targets6.man -x matches4.man -x matches6.man -x *.rej -x *.orig -x .directory ./${MERLIN_TARGET}-original/release/src/router/iptables-1.4.x/extensions ./${MERLIN_TARGET}/release/src/router/iptables-1.4.x/extensions >> merlin-diff.patch

diff -u -B -N ./${MERLIN_TARGET}-original/release/src-rt/Makefile ./${MERLIN_TARGET}/release/src-rt/Makefile >> merlin-diff.patch
diff -u -B -N ./${MERLIN_TARGET}-original/release/src-rt/target.mak ./${MERLIN_TARGET}/release/src-rt/target.mak >> merlin-diff.patch
diff -u -B -N ./${MERLIN_TARGET}-original/release/src/router/config_base ./${MERLIN_TARGET}/release/src/router/config_base >> merlin-diff.patch
diff -u -B -N ./${MERLIN_TARGET}-original/release/src/router/Makefile ./${MERLIN_TARGET}/release/src/router/Makefile >> merlin-diff.patch
diff -u -B -N ./${MERLIN_TARGET}-original/release/src/router/rc/Makefile ./${MERLIN_TARGET}/release/src/router/rc/Makefile >> merlin-diff.patch
diff -u -B -N ./${MERLIN_TARGET}-original/release/src/router/rc/firewall.c ./${MERLIN_TARGET}/release/src/router/rc/firewall.c >> merlin-diff.patch
diff -u -B -N ./${MERLIN_TARGET}-original/release/src/router/rc/openvpn.c ./${MERLIN_TARGET}/release/src/router/rc/openvpn.c >> merlin-diff.patch
diff -u -B -N ./${MERLIN_TARGET}-original/release/src/router/rc/services.c ./${MERLIN_TARGET}/release/src/router/rc/services.c >> merlin-diff.patch
diff -u -B -N ./${MERLIN_TARGET}-original/release/src/router/rc/wan.c ./${MERLIN_TARGET}/release/src/router/rc/wan.c >> merlin-diff.patch
diff -u -B -N ./${MERLIN_TARGET}-original/release/src/router/rc/rc.h ./${MERLIN_TARGET}/release/src/router/rc/rc.h >> merlin-diff.patch
diff -u -B -N ./${MERLIN_TARGET}-original/release/src/router/shared/misc.c ./${MERLIN_TARGET}/release/src/router/shared/misc.c >> merlin-diff.patch
diff -u -B -N ./${MERLIN_TARGET}-original/release/src/router/shared/notify_rc.c ./${MERLIN_TARGET}/release/src/router/shared/notify_rc.c >> merlin-diff.patch

diff -u -B -N ./${MERLIN_TARGET}-original/release/src/router/busybox/config_base ./${MERLIN_TARGET}/release/src/router/busybox/config_base >> merlin-diff.patch
diff -u -B -N ./${MERLIN_TARGET}-original/release/src/router/busybox/include/libbb.h ./${MERLIN_TARGET}/release/src/router/busybox/include/libbb.h >> merlin-diff.patch
diff -u -B -N ./${MERLIN_TARGET}-original/release/src/router/busybox/libbb/lineedit.c ./${MERLIN_TARGET}/release/src/router/busybox/libbb/lineedit.c >> merlin-diff.patch
diff -u -B -N ./${MERLIN_TARGET}-original/release/src/router/busybox/shell/ash.c ./${MERLIN_TARGET}/release/src/router/busybox/shell/ash.c >> merlin-diff.patch
diff -u -B -N ./${MERLIN_TARGET}-original/release/src/router/busybox/shell/hush.c ./${MERLIN_TARGET}/release/src/router/busybox/shell/hush.c >> merlin-diff.patch

# strip file times, root folder names and diff comments
#sed -r -i 's/^(---) ([^\/ ]*\/){2}(release\/[^ \t]*).*/\1 a\/\3/g;s/^(\+\+\+) ([^\/ ]*\/){2}(release\/[^ \t]*).*/\1 b\/\3/g;s/^diff .*//g' merlin-diff.patch


