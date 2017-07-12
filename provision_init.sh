#!/bin/bash
# relink mount setting
# @see https://www.virtualbox.org/ticket/16670
#sudo rm /sbin/mount.vboxsf
#sudo ln -s /usr/lib/VBoxGuestAdditions/mount.vboxsf /sbin/mount.vboxsf

# yum upgrade
sudo yum -y upgrade

# install python 2.7
sudo yum -y install centos-release-scl-rh
sudo yum -y install python27


