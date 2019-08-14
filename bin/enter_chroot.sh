#!/bin/sh -e
#
# enter a chroot on a non-standard path, (ie a different drive)
#

path="$1"
# sanity checks
if [ ! -d "$path" ] ; then
    >&2 echo "$path does not exist"
    exit 1
else
    for i in proc dev sys ; do
        if [ ! -d "$path"/$i ] ; then
            >&2 echo "$path does not seem to be a chroot"
            exit 1
        fi
    done
    if [ ! -L "$path"/bin/sh ] && [ ! -x "$path"/bin/sh ] ; then
        >&2 echo "$path/bin/sh is bad"
        exit 1
    fi
fi

echo "mounting proc,dev,sys..."
mount -t proc proc "$path"/proc 2>/dev/null
mount --rbind /dev "$path"/dev  2>/dev/null
mount --rbind /sys "$path"/sys  2>/dev/null

chroot "$path" /bin/sh

echo "unmounting proc,dev,sys..."
tryumount() {
    if ! sudo umount "$1" 2>/dev/null ; then
        >&2 echo "umount $1 failed... trying to umount -f"
        sleep 1
        if ! sudo umount -f "$1" 2>/dev/null ; then
            >&2 echo "umount -f $1 failed... trying to umount -l"
            sleep 1
            if ! sudo umount -l "$1" 2>/dev/null ; then
                >&2 echo "WARNING: could  not umount -l $1!"
            fi
        fi
    fi
}
tryumount "$path"/dev
tryumount "$path"/proc
tryumount "$path"/sys
