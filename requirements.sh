#!/bin/bash

apt-get update
apt-get install -y debootstrap \
	                 xorriso     \
									 squashfs-tools \
									 git

mkdir -p /root/iso_image/
