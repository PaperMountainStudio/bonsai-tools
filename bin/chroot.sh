#!/bin/sh -e
#
# http://github.com/bonsai-linux/tools
#
# enter a bonsai chroot
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

# if not running as root, restart script
if [ $(id -u) -ne 0 ] ; then
    if type doas > /dev/null ; then
        doas "$0" "$@"
    else
        sudo -E "$0" "$@"
    fi
    exit $?
fi

echo 'mounting proc,dev,sys...'
mount -o bind -t devtmpfs /dev     "$path"/dev     2>/dev/null
mount -o bind -t devpts   /dev/pts "$path"/dev/pts 2>/dev/null
mount -o bind -t proc     /proc    "$path"/proc    2>/dev/null
mount -o bind -t sysfs    /sys     "$path"/sys     2>/dev/null

echo 'copying /etc/resolv.conf'
cp -f /etc/resolv.conf "$path"/etc

OLD_PS1="$PS1"
export PS1='% '

chroot "$path" /bin/sh

tryumount() {
    if ! umount "$1" 2>/dev/null ; then
        sleep 1
        if ! umount -f "$1" 2>/dev/null ; then
            sleep 1
            if ! umount -l "$1" 2>/dev/null ; then
                >&2 echo "WARNING: could  not umount -l $1!"
            fi
        fi
    fi
}

echo "unmounting proc,dev,sys..."
sleep 1
tryumount "$path"/dev
tryumount "$path"/proc
tryumount "$path"/sys

export PS1="$OLD_PS1"

echo "Exited chroot!"
