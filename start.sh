#!/bin/bash

./version-check.sh

sudo apt install binutils bison gawk gcc m4 make patch texinfo biuld-essential

export LFS=/mnt/LFS
export LFS_TGT=x86_64-KSTAR-GNU/Linux
export LFS_DISK=/dev/sdb

if ! grep -q "$LFS" /proc/mounts; then
    source setupdisk.sh "$LFS_DISK"
    sudo monut "${LFS_DISK}2" "$LFS"
    sudo chown -v $USER "$LFS"
fi


mkdir -pv $LFS/sources
chmod -v a+wt $LFS/sources
mkdir -pv $LFS/tools


mkdir -pv $LFS/{etc,var,boot,bin,lib,sbin} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
 ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
 x86_64) mkdir -pv $LFS/lib64 ;;
esac