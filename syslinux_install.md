# BIOS SYSLINUX INSTALL

1. make sure your drive has the "boot" flag enabled `(fdisk 'a' key)`

2. make directory and copy files

    ```bash
    mkdir -p /boot/syslinux
    cp -f /src/pkgs/syslinux/share/syslinux/*.c32 /boot/syslinux/
    cp -f /src/pkgs/syslinux/share/syslinux/*.bin /boot/syslinux/
    ```
3. install to drive
   
    ```bash
    extlinux --install /boot/syslinux
    ```

4. Install the MBR

    ```bash
    dd bs=440 count=1 conv=notrunc if=/src/pkgs/syslinux/share/syslinux/mbr.bin of=/dev/sdX
    ```

5. create settings

    ```bash
    cat > /boot/syslinux/syslinux.cfg << EOF
    * BIOS: /boot/syslinux/syslinux.cfg
    * UEFI: esp/EFI/syslinux/syslinux.cfg
    PROMPT 0
    TIMEOUT 0
    DEFAULT bonsai

    LABEL bonsai
        LINUX ../vmlinuz
        APPEND root=/dev/sdXx rw
    EOF
    ```
    
    change PROMPT to 0 and TIMEOUT to 50 for a prompt

6. make sure ext4 filesytem uses 32 bit sizes, (64 incompatible with `syslinux`)

    ```bash
    e2fsck -f /dev/sdXx 
    resize2fs -s /dev/sdXx
    ```
