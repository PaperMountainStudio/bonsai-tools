# tools

Handy scripts used by the [bonsai](http://github.com/bonsai-linux/bonsai) developers.

<strong> **WARNING: DO NOT RUN SCRIPTS YOU HAVE NOT READ.** </strong>

## 1. `pkgskel`

Dumps a pkgfile skeleton to stdout. Handy for not having to type it out each time.

Example: `pkgskel > pkgfile`

## 2. `chroot.sh`

Handy helper for chrooting into your rootfs.

Two ways of using it:

1. With an cmdline argument:

`./chroot.sh /path/to/chroot`

2. Or without any arguments, reading from your `$root` variable in the environment:

```sh
export root=/path/to/chroot
./chroot.sh
```

## 3. `mkiso.sh`

Assuming you have the required programs installed 
in your chroot, this will zip up your rootfs and make it
into a bootable initrd `.iso` for use with `qemu`.

## 4. `qemu.sh`

This will launch `qemu` with sane arguments to boot a `.iso` 
that you created with the script above.
