#!/bin/bash
# relink mount setting
# @see https://www.virtualbox.org/ticket/16670
#sudo rm /sbin/mount.vboxsf
#sudo ln -s /usr/lib/VBoxGuestAdditions/mount.vboxsf /sbin/mount.vboxsf

# yum upgrade
sudo yum -y upgrade

# install git
sudo yum -y install git

# install python 2.7
sudo yum -y install centos-release-scl-rh
sudo yum -y install python27

# enable python 2.7
sudo cat <<__END_OF_MESSAGE__ > /etc/profile.d/python27.sh
#!/bin/bash

source /opt/rh/python27/enable
export X_SCLS="`scl enable python27 'echo $X_SCLS'`"
__END_OF_MESSAGE__

# install word2vec
if [ ! -d /vagrant/word2vec ]
then
    cd /vagrant
    git clone https://github.com/svn2github/word2vec.git
    cd word2vec
    make
fi

# install MeCab
if [ ! -d /usr/local/mecab ]
then
	sudo yum -y install gcc-c++

    sudo mkdir /usr/local/mecab
    cd /usr/local/src
    wget  wget -O mecab-0.996.tar.gz "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE"
    tar xvfz mecab-0.996.tar.gz
    cd mecab-0.996
    sudo ./configure --enable-utf8-only --prefix=/usr/local/mecab
    sudo make
    sudo make install

    cd /usr/local/src
    wget -O mecab-ipadic-2.7.0-20070801.tar.gz "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM"
    tar xvfz mecab-ipadic-2.7.0-20070801.tar.gz
    cd mecab-ipadic-2.7.0-20070801
    sudo ./configure --prefix=/usr/local/mecab --with-mecab-config=/usr/local/mecab/bin/mecab-config --with-charset=utf8
    sudo make
    sudo make install
fi

# enable mecab
sudo cat <<__END_OF_MESSAGE__ > /etc/profile.d/mecab.sh
#!/bin/bash

export PATH="$PATH:/usr/local/mecab/bin
__END_OF_MESSAGE__



