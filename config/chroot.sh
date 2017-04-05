#!/bin/bash

# This is a script to configure a fresh ubuntu image as per the standards here:
# https://github.com/UKHomeOffice/development_environment

update_and_install_base_packages() {
  apt-get update
  apt-get install -y casper lupin-casper ubiquity ubiquity-frontend-gtk \
	  linux-generic linux-headers-generic ubuntu-minimal ubuntu-standard \
	  ubuntu-desktop
  apt-get clean
}

set_kernel_version() {
  export kversion=`cd /boot && ls -1 vmlinuz-* | tail -1 | sed 's@vmlinuz-@@'`
  depmod -a $kversion
  update-initramfs -u -k $kversion
}

update_and_install_base_packages

set_kernel_version
