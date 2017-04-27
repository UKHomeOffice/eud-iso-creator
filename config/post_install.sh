#!/bin/bash

. image_config/base
. image_config/docker
. image_config/kubectl_minikube
. image_config/packer
. image_config/sublime
. image_config/configure_login
. image_config/display_link_driver

FILE_LOCATION="image_config/files"

echo "Installing docker"
  separator
    docker_role
  separator

echo "Installing Sublime"
  separator
    sublime_role
  separator

echo "Installing kubectl / minikube"
  separator
    kubectl_minikube_role
  separator

echo "Installing packer"
  separator
    packer_role
  separator

echo "Installing Display Link Driver"
  separator
    display_link_driver_role
  separator

echo "Configuring user logins"
  separator
    configure_login_role
  separator

echo "Please don't forget to change the UID of the admin user to 999 in order to hide them"
echo "Open passwd in a text editor and change the UID from 1000 to 999"
