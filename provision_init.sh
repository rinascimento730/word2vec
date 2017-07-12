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

# enable python 2.7
sudo cat <<__END_OF_MESSAGE__ >/etc/profile.d/python27.sh
#!/bin/bash

source /opt/rh/python27/enable
export X_SCLS="`scl enable python27 'echo $X_SCLS'`"
__END_OF_MESSAGE__



