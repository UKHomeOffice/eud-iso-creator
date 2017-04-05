#!/bin/bash

# This is a script to configure a fresh ubuntu image as per the standards here:
# https://github.com/UKHomeOffice/development_environment

update_and_install_packages() {
  apt-get update
  apt-get install casper lupin-casper ubiquity ubiquity-frontend-gtk
  apt-get clean
}

update_and_install_packages
