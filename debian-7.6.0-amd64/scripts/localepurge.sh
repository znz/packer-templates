#!/bin/bash -eux

export DEBIAN_FRONTEND=noninteractive
apt-get -y install localepurge
echo localepurge localepurge/nopurge string "ja, ja_JP.UTF-8" | debconf-set-selections
dpkg-reconfigure localepurge
localepurge
