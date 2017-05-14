#!/bin/bash
for KERNEL_FOLDER in "src-rt-6.x.4708" "src-rt-7.14.114.x/src" "src-rt-7.x.main/src"; do
  SRC="/mnt/hgfs/sandbox/RNG/asuswrt_blackfuel"
  DST="$HOME/asuswrt-merlin/release/$KERNEL_FOLDER/linux/linux-2.6.36"

  cp $SRC/random.h $DST/include/linux
  cp $SRC/random.c $DST/drivers/char
  cp $SRC/random32.c $DST/lib
  cp $SRC/trace/random.h $DST/include/trace/events
done

