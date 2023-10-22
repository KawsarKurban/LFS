#!/bin/bash

./version-check.sh

sudo apt install binutils bison gawk gcc m4 make patch texinfo biuld-essential

export LFS=/mnt/lfs
export LFS_TGT=x86_64-KSTAR-GNU/Linux