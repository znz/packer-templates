#!/bin/bash -eux

# Clean up
apt-get -y --purge remove linux-headers-$(uname -r) build-essential
apt-get -y --purge autoremove
apt-get -y purge $(dpkg --list |grep '^rc' |awk '{print $2}')
apt-get -y purge $(dpkg --list |egrep 'linux-image-[0-9]' |awk '{print $3,$2}' |sort -nr |tail -n +2 |grep -v $(uname -r) |awk '{ print $2}')
apt-get -y clean

# Cleanup Virtualbox
rm -rf VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?

# Remove files from cache
find /var/cache -type f -delete -print

# Remove guest addition source
rm -rf /usr/src/virtualbox-ose-guest*
rm -rf /usr/src/vboxguest*

# Zero out the free space to save space in the final image:
echo "Zeroing device to make space..."
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Remove history file
unset HISTFILE
rm ~/.bash_history /home/vagrant/.bash_history

# Block until the empty file has been removed, otherwise, Packer
# will try to kill the box while the disk is still full and that's bad
sync
