#!/bin/bash

# This is a script to configure a fresh ubuntu image as per the standards here:
# https://github.com/UKHomeOffice/development_environment

# Find script directory:
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

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
. image_config/docker
. image_config/kubectl_minikube
. image_config/virtualbox_role
. image_config/vagrant
. image_config/packer
. image_config/slack
. image_config/sysdig
. image_config/sublime
. image_config/chrome
. image_config/display_link_driver

echo "Configuring image to make a bootable installation disk"
  separator
  update_and_install_base_packages
  set_kernel_version

echo "Performing generic role to install packages / configure system"
  separator
  generic_role

echo "Installing packages related to GUI"
  separator
  gui_role

echo "Performing OS hardening tasks"
  separator
  os_hardening_role

echo "Performing SSH hardening tasks"
  separator
  ssh_hardening_role

echo "Configuring ip tables"
  separator
  ip_tables_role

echo "Configuring grub cmdline"
  separator
  grub_cmdline_role

echo "Performing Audit hardening tasks"
  separator
  audit_hardening_role

echo "Installing OpenJDK"
  separator
  open_jdk_role

echo "Installing Docker"
  separator
  docker_role

echo "Installing Kubectl & Minikube"
  separator
  kubectl_minikube_role

echo "Installing Virtual Box"
  separator
  virtualbox_role

echo "Installing Vagrant"
  separator
  vagrant_role

echo "Installing Packer"
  separator
  packer_role

echo "Installing Slack"
  separator
  slack_role

echo "Installing Sysdig"
  separator
  sysdig_role

echo "Installing Sublime"
  separator
  sublime_role

echo "Installing Chrome"
  separator
  chrome_role

echo "Installing Display Link Driver"
  separator
  display_link_driver_role

echo "Installing / Configuring ClamAV"
  separator
  clamav_role

exit 0
