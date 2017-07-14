#!/bin/bash

# set install version
PYTHON2="2.7"
PYTHON3="3.3"
PYTHON2_FULL="2.7.13"
PYTHON3_FULL="3.3.6"
MECAB="0.996"
IPADIC="2.7.0-20070801"

#set PATH
SRC_TO="/usr/local/src"
PYTHON_AT="/opt/local"
PIP_AT=${HOME}"/.local"
MECAB_AT="/usr/local/mecab"


# yum upgrade
sudo yum -y upgrade

# install git
sudo yum -y install git

# install dev tools
sudo yum -y groupinstall "Development tools"
sudo yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel

# install python 2
if [ ! -e ${PYTHON_AT}/bin/python${PYTHON2} ]
then
    # get python 2
    cd ${SRC_TO}
    sudo curl -O https://www.python.org/ftp/python/${PYTHON2_FULL}/Python-${PYTHON2_FULL}.tgz
    sudo tar zxf Python-${PYTHON2_FULL}.tgz

    # install python 2.7.13
    cd Python-${PYTHON2_FULL}
    sudo ./configure --prefix=${PYTHON_AT}
    sudo make && sudo make altinstall
fi

# install python3
if [ ! -e ${PYTHON_AT}/bin/python${PYTHON3} ]
then
    # get python3
    cd ${SRC_TO}
    sudo curl -O https://www.python.org/ftp/python/${PYTHON3_FULL}/Python-${PYTHON3_FULL}.tgz
    sudo tar zxf Python-${PYTHON3_FULL}.tgz

    # install python3
    cd Python-${PYTHON3_FULL}
    sudo ./configure --prefix=${PYTHON_AT}
    sudo make && sudo make altinstall
fi

# enable python
if [ ! `echo  $PATH | grep ${PYTHON_AT}'/bin'` ]
then
  echo 'export PATH=$PATH:'${PYTHON_AT}'/bin' >> ~/.bash_profile
  source ~/.bash_profile
fi

# install pip2
if [ ! -e ${PIP_AT}/bin/pip${PYTHON2} ]
then
	cd ${SRC_TO}
    # install pip
    sudo curl -O https://bootstrap.pypa.io/get-pip.py
    ${PYTHON_AT}/bin/python${PYTHON2} get-pip.py --user

    #install virtualenv
    ${PIP_AT}/pip${PYTHON2} install --user virtualenv

    # install distribute
    ${PIP_AT}/bin/bin/pip${PYTHON2} install -U setuptools --user
fi

# install pip3
if [ ! -e ${PIP_AT}/bin/pip${PYTHON3} ]
then
	cd ${SRC_TO}
    # install pip
    sudo curl -O https://bootstrap.pypa.io/get-pip.py
    ${PYTHON_AT}/bin/python${PYTHON3} get-pip.py --user

    #install virtualenv
    ${PIP_AT}/bin/pip${PYTHON3} install --user virtualenv

    # install distribute
    ${PIP_AT}/bin/pip${PYTHON3} install -U setuptools --user
fi

# enable pip
if [ ! `echo  $PATH | grep ${PIP_AT}'/bin'` ]
then
  echo 'export PATH=$PATH:'${PIP_AT}'/bin' >> ~/.bash_profile
  source ~/.bash_profile
fi

# install word2vec
if [ ! -e /vagrant/word2vec ]
then
    cd /vagrant
    git clone https://github.com/svn2github/word2vec.git
    cd word2vec
    sudo make
fi

# install MeCab
if [ ! -e ${MECAB_AT} ]
then
    # install gcc-c++
	sudo yum -y install gcc-c++

    # install mecab
    sudo mkdir /usr/local/mecab
    cd ${SRC_TO}
    sudo wget -O mecab-${MECAB}.tar.gz "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE"
    sudo tar xvfz mecab-${MECAB}.tar.gz
    cd mecab-${MECAB}
    sudo ./configure --enable-utf8-only --prefix=${MECAB_AT}
    sudo make
    sudo make install

    # install ipadic
    cd ${SRC_TO}
    sudo wget -O mecab-ipadic-${IPADIC}.tar.gz "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM"
    sudo tar xvfz mecab-ipadic-${IPADIC}.tar.gz
    cd mecab-ipadic-${IPADIC}
    sudo ./configure --prefix=${MECAB_AT} --with-mecab-config=${MECAB_AT}/bin/mecab-config --with-charset=utf8
    sudo make
    sudo make install
fi

# enable libmecab
if [ ! `cat /etc/ld.so.conf | grep ${MECAB_AT}'/lib'` ]
then
  sudo chmod 777 /etc/ld.so.conf
  echo ${MECAB_AT}'/lib' >> /etc/ld.so.conf
  sudo chmod 644 /etc/ld.so.conf
  sudo ldconfig
fi

# enable mecab
if [ ! `echo  $PATH | grep ${MECAB_AT}'/bin'` ]
then
  echo 'export PATH=$PATH:'${MECAB_AT}'/bin' >> ~/.bash_profile
  source ~/.bash_profile
fi

# install mecab-python
${PIP_AT}/bin/pip${PYTHON2} install --user mecab-python
${PIP_AT}/bin/pip${PYTHON3} install --user mecab-python3
