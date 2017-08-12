#!/bin/bash
MERLIN_TARGET="asuswrt-merlin"
cd
cd ${MERLIN_TARGET}/release/src-rt-6.x.4708
make clean
cd
rm merlin-diff.patch
for KERNEL_FOLDER in "src-rt-6.x.4708" "src-rt-7.14.114.x/src" "src-rt-7.x.main/src"; do
  diff -u -B -N ./${MERLIN_TARGET}-original/release/${KERNEL_FOLDER}/linux/linux-2.6.36/config_base.6a ./${MERLIN_TARGET}/release/${KERNEL_FOLDER}/linux/linux-2.6.36/config_base.6a >> merlin-diff.patch
done

# strip file times, root folder names and diff comments
sed -r -i 's/^(---) ([^\/ ]*\/){2}(release\/[^ \t]*).*/\1 a\/\3/g;s/^(\+\+\+) ([^\/ ]*\/){2}(release\/[^ \t]*).*/\1 b\/\3/g;s/^diff .*//g' merlin-diff.patch


