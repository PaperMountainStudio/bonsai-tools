#!/bin/sh -e
#
# http://github.com/bonsai-linux/tools
#
# create a ramfs iso of our rootfs
#
# Requires: bonsai-{core,kernel,init}, syslinux
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

case "$1" in
    -h|*help)
        >&2 echo 'usage: ./mkiso.sh /path/to/chroot'
        exit
esac

# -*-*- CONFIG *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
builddir="$PWD"/build # where we should output to
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

if [ "$1" ] ; then
    root="$1"
elif [ -z "$root" ] ; then
    >&2 echo "No root provided."
    exit 1
fi

msg() { printf "%s\n" "→ $*" ; }

bonsai=$root/src/bonsai

rm -r "${builddir:?}" 2>/dev/null ||: ; mkdir -p "$builddir"

msg 'relinking world...'
$bonsai --relink-world --chroot

msg 'zipping up the root file system...'
cd "$root"
find . | cpio -R root:root -H newc -o | gzip > "$builddir"/rootfs.gz

cd "$builddir"

msg 'copying kernel files...'
cp -f "$root"/boot/vmlinuz ./vmlinuz
cp -f "$root"/boot/System.map ./System.map
cp -f "$root"/boot/config ./config

msg 'copying bootloader...'
cp -f "$root"/src/pkgs/syslinux/share/syslinux/isolinux.bin ./isolinux.bin
cp -f "$root"/src/pkgs/syslinux/share/syslinux/ldlinux.c32  ./ldlinux.c32

msg 'creating syslinux config...'
echo 'default vmlinuz initrd=rootfs.gz' > isolinux.cfg

msg 'creating iso...'
xorriso \
    -as mkisofs \
    -o "$builddir"/bonsai.iso \
    -b isolinux.bin \
    -c boot.cat \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table .
