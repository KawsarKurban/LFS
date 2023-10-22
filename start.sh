#!/bin/bash

[ ! -e /etc/bash.bashrc ] || sudo mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE

sudo groupadd lfs
sudo useradd -s /bin/bash -g lfs -m -k /dev/null lfs
echo -e "lfs\nlfs" | sudo passwd lfs

sudo su - lfs
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/LFS
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF

source ~/.bash_profile


./version-check.sh

sudo apt install binutils bison gawk gcc m4 make patch texinfo biuld-essential

export LFS=/mnt/LFS
export LFS_TGT=x86_64-KSTAR-GNU/Linux
export LFS_DISK=/dev/sdb

if ! grep -q "$LFS" /proc/mounts; then
    source setupdisk.sh "$LFS_DISK"
    sudo mount "${LFS_DISK}2" "$LFS"
    sudo chown -v $USER "$LFS"
fi

mkdir -pv $LFS/sources
chmod -v a+wt $LFS/sources
mkdir -pv $LFS/tools
mkdir -pv $LFS/{etc,var,boot,bin,lib,sbin} $LFS/usr/{bin,lib,sbin}

chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}

for i in bin lib sbin; do
 ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
 x86_64) mkdir -pv $LFS/lib64 ;;
esac

cp -rf *.sh md5sums wget-list Chapter* $LFS/sources
source $LFS/sources/download.sh
export PATH="$LFS/tools/bin:$PATH"

#CPU Core
export MAKEFLAGS='-j8'

source packageinstall.sh 5 binutils
source packageinstall.sh 5 gcc
