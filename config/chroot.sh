#!/bin/bash

# This is a script to configure a fresh ubuntu image as per the standards here:
# https://github.com/UKHomeOffice/development_environment

# Find script directory:
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
FILE_LOCATION="image_config/files"
export LC_ALL="C.UTF-8"
export DEBIAN_FRONTEND=noninteractive

# Import functions
. image_config/base
. image_config/generic
. image_config/gui
. image_config/os_hardening
. image_config/ssh_hardening
. image_config/ip_tables
. image_config/grub_cmdline
. image_config/audit_hardening
. image_config/open_jdk
. image_config/virtualbox
. image_config/vagrant
. image_config/slack
. image_config/sysdig
. image_config/clamav
. image_config/chrome
. image_config/display_link_driver

echo "Configuring image to make a bootable installation disk"
  separator
    update_and_install_base_packages
    set_kernel_version
  separator

echo "Performing generic role to install packages / configure system"
  separator
    generic_role
  separator

echo "Installing packages related to GUI"
  separator
    gui_role
  separator

echo "Performing OS hardening tasks"
  separator
    os_hardening_role
  separator

echo "Performing SSH hardening tasks"
  separator
    ssh_hardening_role
  separator

echo "Configuring ip tables"
  separator
    ip_tables_role
  separator

echo "Configuring grub cmdline"
  separator
    grub_cmdline_role
  separator

echo "Performing Audit hardening tasks"
  separator
    audit_hardening_role
  separator

echo "Installing OpenJDK"
  separator
    open_jdk_role
  separator

echo "Installing Virtual Box"
  separator
    virtualbox_role
  separator

echo "Installing Vagrant"
  separator
    vagrant_role
  separator

echo "Installing Slack"
  separator
    slack_role
  separator

echo "Installing Sysdig"
  separator
    sysdig_role
  separator

echo "Installing Chrome"
  separator
    chrome_role
  separator

echo "Installing Display Link Driver"
  separator
    display_link_driver_role
  separator

echo "Installing / Configuring ClamAV"
  separator
    clamav_role
  separator

echo "Cleaning up fs and adding installation user"
  separator
    rm -rf /install/
  separator

exit 0
