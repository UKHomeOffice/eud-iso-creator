# eud-iso-creator

This is a simple script to generate an ISO that is functionally the same as:

https://github.com/UKHomeOffice/development_environment

The idea is that a script is run to generate an ISO so that everything is centralized instead of using the ansible playbooks with their many dependencies.

## Things to be aware of

After installation, run the post_install.sh script in the /root/install directory of the installed file system.

## Instructions on how to use

After generating the ISO you must copy this onto a USB stick:
`dd if=<location of ISO>.iso of=/dev/sd[a-z] bs=4M status=progress`
Where sd[a-z] is the location of the USB stick

After this boot from the USB stick.

After the live disk has loaded, open a terminal and change to root:
`sudo su -`
Then run the ubuntu installer:
`ubiquity`

## If an SSD is present
If an SSD is present in the computer then you must install grub manually as this step of the installation will fail.

To do so, open another terminal as the root user - 
having installed the system onto the hard disk you should now have access to the newly created logical volumes.
Run the following command to refresh the list of logical volumes:
`vgchange -a y`
You should get a message about logical volumes being added.

Next, you must mount the filesystem - to do so, run the following (still as root):
`mount /dev/<Volume group name>/<logical volume name of root filesystem>` /mnt/
Next you must mount the filesystem containing the boot directory into the correct place of the mounted root filesystem.
`mount /dev/nvme0n1p1 /mnt/boot`

Having mounted the filesystem correctly you must now bind the dev / proc / sys directories into the mounted filesystem to be able to install grub to it.
To do so - the following line is useful:
`for i in dev proc sys ; do mount -B /$i /mnt/$i ; done`

Finally you must chroot inside of this filesystem:
`chroot /mnt/`

Inside, you must do the following:
`grub-install /dev/nvme0n1`
Then generate the grub config:
`grub-mkconfig -o /boot/grub/grub.cfg`

Finally, change the UID of the admin user to 999 in order to hide them from the user login screen:
`usermod -u 999 <admin username>`

Log out of the chroot environment using: Ctrl-D

Now you can complete the installation / reboot, make sure to remove the USB stick after rebooting.


## After Installation

After installation you must log in as root and while connected to the internet, run the post_install.sh script present in the /root/install/ directory.

If you can not log in as root from the GUI, you will have to log in using a tty - if this is the case, you will find it straightforward to connect to the network using nmtui - alternatively, log into the guest account and configure the Wifi from there.

end
