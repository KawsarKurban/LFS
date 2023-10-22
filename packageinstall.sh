#!/bin/bash

CHAPTER="$1"
PACKAGE="$2"

cat md5sums | grep -i "$PACKAGE" | grep -i -v "\.patch" | while read line; do
    FILENAME="$(echo $line | cut -d ' ' -f 2)"
    DIRNAME="$(echo "$PACKAGE" | sed 's/\(.*\)\.tar\..*/\1/')"
    mkdir -pv $DIRNAME
    echo "===>Extracting $PACKAGE..."
    tar -xf "$FILENAME" -C "$DIRNAME"
    pushd $DIRNAME
    if [ "$(ls -A1 | wc -l)" == "1" ]; then
        mv $(ls -A1)/* ./
    fi

    echo "===>Compiling $PACKAGE..."
    sleep 5
    
    mkdir -pv "$LFS/var/log/Chapter$CHAPTER/"
    if ! source "$LFS/sources/Chapter$CHAPTER/$PACKAGE.sh" 2>&1 | tee "$LFS/var/log/Chapter$CHAPTER/$PACKAGE.log"; then
        echo "Compiling $PACKAGE failed!"
        popd
        exit 1
    fi

    echo "===>Done compiling $PACKAGE!"
    popd

done

