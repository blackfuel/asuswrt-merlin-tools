#!/bin/bash

DST="/mnt/hgfs/sandbox/__blackfuel_release_new"
rm -rf $DST
mkdir -p $DST

for KERNEL_FOLDER in "src-rt-6.x.4708" "src-rt-7.14.114.x/src" "src-rt-7.x.main/src"; do
  SRC="$HOME/asuswrt-merlin/release/$KERNEL_FOLDER/image"
  mv -v $SRC/RT-* $DST
done

for HASH_FILE in $DST/RT-*/sha256sum.txt; do
  cat $HASH_FILE >> $DST/sha256sums.txt
done

