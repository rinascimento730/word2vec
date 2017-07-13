#!/bin/bash

# set install version
PYTHON2="2.7"
PYTHON3="3.3"
PYTHON2_FULL="2.7.13"
PYTHON3_FULL="3.3.6"
MECAB="0.996"
IPADIC="2.7.0-20070801"

# yum upgrade
sudo yum -y upgrade

# install git
sudo yum -y install git

# install dev tools
sudo yum -y groupinstall "Development tools"
sudo yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel

# install python 2
if [ ! -e /opt/local/bin/python${PYTHON2} ]
then
    # get python 2
    cd /usr/local/src
    curl -O https://www.python.org/ftp/python/${PYTHON2_FULL}/Python-${PYTHON2_FULL}.tgz
    tar zxf Python-${PYTHON2_FULL}.tgz

    # install python 2.7.13
    cd Python-${PYTHON2_FULL}
    sudo ./configure --prefix=/opt/local
    sudo make && sudo make altinstall
fi

# install python3
if [ ! -e /opt/local/bin/python${PYTHON3} ]
then
    # get python3
    cd /usr/local/src
    curl -O https://www.python.org/ftp/python/${PYTHON3_FULL}/Python-${PYTHON3_FULL}.tgz
    tar zxf Python-${PYTHON3_FULL}.tgz

    # install python3
    cd Python-${PYTHON3_FULL}
    sudo ./configure --prefix=/opt/local
    sudo make && sudo make altinstall
fi

# install pip2
if [ ! -e /opt/local/bin/pip${PYTHON2} ]
then
    # install pip
    curl -kL https://bootstrap.pypa.io/get-pip.py | /opt/local/bin/python${PYTHON2}

    #install virtualenv
    sudo /opt/local/bin/pip${PYTHON2} install virtualenv

    # install distribute
    pip${PYTHON2} install -U setuptools --user
fi

# install pip3
if [ ! -e /opt/local/bin/pip${PYTHON3} ]
then
    # install pip
    curl -kL https://bootstrap.pypa.io/get-pip.py | /opt/local/bin/python${PYTHON3}

    #install virtualenv
    sudo /opt/local/bin/pip${PYTHON3} install virtualenv

    # install setuptools
    pip${PYTHON3} install -U setuptools --user
fi

# enable python
sudo cat <<__END_OF_MESSAGE__ > /etc/profile.d/python.sh
#!/bin/bash

export PATH="$PATH:/opt/local/bin"
__END_OF_MESSAGE__
source /etc/profile.d/python.sh

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
    wget -O mecab-${MECAB}.tar.gz "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE"
    tar xvfz mecab-${MECAB}.tar.gz
    cd mecab-${MECAB}
    sudo ./configure --enable-utf8-only --prefix=/usr/local/mecab
    sudo make
    sudo make install

    cd /usr/local/src
    wget -O mecab-ipadic-${IPADIC}.tar.gz "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM"
    tar xvfz mecab-ipadic-${IPADIC}.tar.gz
    cd mecab-ipadic-${IPADIC}
    sudo ./configure --prefix=/usr/local/mecab --with-mecab-config=/usr/local/mecab/bin/mecab-config --with-charset=utf8
    sudo make
    sudo make install

    pip${PYTHON2} install --user mecab-python
    pip${PYTHON3} install --user mecab-python3
fi

# enable mecab
sudo cat <<__END_OF_MESSAGE__ > /etc/profile.d/mecab.sh
#!/bin/bash

export PATH="$PATH:/usr/local/mecab/bin"
__END_OF_MESSAGE__
source /etc/profile.d/mecab.sh

