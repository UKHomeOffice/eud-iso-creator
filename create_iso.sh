#!/bin/bash

# This is a script to generate a usable ISO that is functionally the same as:
# https://github.com/UKHomeOffice/development_environment

check_for_requirements() {
  PACKAGES=$(dpkg -l)
  if [[ -z $(echo "$PACKAGES"| grep "debootstrap") || \
	  -z $(echo "$PACKAGES" | grep "xorriso") || \
	  -z $(echo "$PACKAGES" | grep "squashfs-tools") ]]; then
    separator
    echo "This script requires you have debootstrap, xorriso and squashfs-tools installed,"
    echo "please install them then come back and try again."
    exit 1
  fi
  if [[ "$USER" != "root" ]]; then
    echo "This script requires you run it as root"
    echo "Please check your permissions then come back and try again"
    exit 1
  fi
  echo "Looks good, carrying on"
}

prepare_directories() {
  export WORK=~/work
  export CD=~/cd
  export FORMAT=squashfs
  export FS_DIR=casper
  mkdir -p ${CD}/{${FS_DIR},boot/grub} ${WORK}/rootfs
}

pull_down_image() {
  debootstrap xenial ${WORK}/rootfs
}

mount_filesystem() {
  mount --bind /dev ${WORK}/rootfs/dev
  mount -t proc proc ${WORK}/rootfs/proc
  mount -t sysfs sysfs ${WORK}/rootfs/sys
}

unmount_filesystem() {
  umount ${WORK}/rootfs/proc
  umount ${WORK}/rootfs/sys
  umount ${WORK}/rootfs/dev
}

prepare_image_for_use() {
  mkdir -p ${WORK}/rootfs/install/
  rsync -a config/sources/*                  ${WORK}/rootfs/etc/apt/sources.list.d/
  mkdir -p                                   ${WORK}/rootfs/root/install/image_config/
  rsync -a config/chroot.sh                  ${WORK}/rootfs/root/install/
  rsync -a config/post_install.sh            ${WORK}/rootfs/root/install/
  rsync -a config/README.md                  ${WORK}/rootfs/root/install/
  rsync -a config/image_config/              ${WORK}/rootfs/root/install/image_config/
}

tag_image() {
  LOG_FILE=${WORK}/rootfs/root/INSTALLATION_INFO
  CREATOR=$(awk -F: '($3 >= 1000) {printf "%s:%s\n",$1,$3}' /etc/passwd | grep -v nobody)
  echo "$0 $@ ran on $DATE"                              >$LOG_FILE
  echo "Branch: $(git branch)"                          >>$LOG_FILE
  echo "Version: $(git describe --tags)"                >>$LOG_FILE
  echo "Commit: $(git log --format=oneline | head -n1)" >>$LOG_FILE
  echo "Git URL: $(git remote get-url --all origin)"    >>$LOG_FILE
  echo "Created by: $CREATOR using $(hostname)"         >>$LOG_FILE
  separator                                             >>$LOG_FILE
}

configure_image() {
  chroot ${WORK}/rootfs /root/install/chroot.sh
  rsync -a config/image_config/files/80multi ${WORK}/rootfs/lib/partman/recipes/30atomic
  export kversion=`cd ${WORK}/rootfs/boot && ls -1 vmlinuz-* | tail -1 | sed 's@vmlinuz-@@'`
  cp -vp ${WORK}/rootfs/boot/vmlinuz-${kversion} ${CD}/${FS_DIR}/vmlinuz
  cp -vp ${WORK}/rootfs/boot/initrd.img-${kversion} ${CD}/${FS_DIR}/initrd.img
  cp -vp ${WORK}/rootfs/boot/memtest86+.bin ${CD}/boot
}

prepare_cd_directory() {
  chroot ${WORK}/rootfs dpkg-query -W --showformat='${Package} ${Version}\n' | \
	                                 sudo tee ${CD}/${FS_DIR}/filesystem.manifest
  cp -v ${CD}/${FS_DIR}/filesystem.manifest{,-desktop}
  REMOVE='ubiquity casper user-setup os-prober libdebian-installer4'
  for i in $REMOVE ; do
    sudo sed -i "/${i}/d" ${CD}/${FS_DIR}/filesystem.manifest
    sudo sed -i "/${i}/d" ${CD}/${FS_DIR}/filesystem.manifest-desktop
  done
  mksquashfs ${WORK}/rootfs ${CD}/${FS_DIR}/filesystem.${FORMAT} -noappend
  echo -n $(sudo du -s --block-size=1 ${WORK}/rootfs | tail -1 | awk '{print $1}') \
	                                  | sudo tee ${CD}/${FS_DIR}/filesystem.size
  find ${CD} -type f -print0 | xargs -0 md5sum | sed "s@${CD}@.@" | \
	                           grep -v md5sum.txt | sudo tee -a ${CD}/md5sum.txt
  rsync -a config/image_config/files/grub.cfg ${CD}/boot/grub/grub.cfg
  grub-mkrescue -o ~/eud-environment-$(date +%Y-%m-%d-%H-%M-%S).iso ${CD} -- -iso-level 4
}

separator() {
  echo "################################################################################"
}

DATE=$(date)

echo "Checking for requirements"
  separator
    check_for_requirements
  separator

echo "Preparing work directories"
  separator
    prepare_directories
  separator

echo "Downloading Ubuntu"
  separator
    pull_down_image
    prepare_image_for_use
    tag_image
  separator

echo "Configuring image"
  separator
    mount_filesystem
    configure_image
    unmount_filesystem
  separator

echo "Preparing the filesystem for the creation of the ISO"
  separator
    prepare_cd_directory
  separator

exit 0
