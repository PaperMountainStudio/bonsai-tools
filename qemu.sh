#!/bin/sh
#
# http://github.com/bonsai-linux/tools
#
# launches qemu with sane arguments for our iso
#

iso="$1" ; [ -z "$iso" ] && iso=./build/bonsai.iso

# use half of total ram
set -- $(free -h | awk 'NR==2{print $2}NR==2{print $3}')
ram="${1%.*}"
ram="$(( $ram / 2 ))G"

qemu-system-x86_64 \
    -daemonize \
    -m $ram \
    -vga std \
    -usb \
    -device usb-tablet \
    -cdrom "$iso" &

    #-enable-kvm
