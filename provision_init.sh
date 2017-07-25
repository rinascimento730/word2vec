#!/bin/bash

# set install version
PYTHON2="2.7"
PYTHON3="3.6"
PYTHON2_FULL="2.7.13"
PYTHON3_FULL="3.6.2"
MECAB="0.996"
IPADIC="2.7.0-20070801"

#set PATH
SRC_TO="/usr/local/src"
PYTHON_AT="/opt/local"
PIP2_AT=${HOME}"/.local"
PIP3_AT="/opt/local"
MECAB_AT="/usr/local/mecab"


# yum upgrade
sudo yum -y upgrade

# install git
sudo yum -y install git

# install dev tools
sudo yum -y groupinstall "Development tools"
sudo yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel boost-devel

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
if [ ! -e ${PIP2_AT}/bin/pip${PYTHON2} ]
then
	cd ${SRC_TO}
    # install pip
    sudo curl -O https://bootstrap.pypa.io/get-pip.py
    ${PYTHON_AT}/bin/python${PYTHON2} get-pip.py --user

    #install virtualenv
    ${PIP2_AT}/pip${PYTHON2} install --user virtualenv

    # install distribute
    ${PIP2_AT}/bin/bin/pip${PYTHON2} install -U setuptools --user
fi

# install pip3
if [ ! -e ${PIP3_AT}/bin/pip${PYTHON3} ]
then
	cd ${SRC_TO}
    # install pip
    sudo curl -O https://bootstrap.pypa.io/get-pip.py
    ${PYTHON_AT}/bin/python${PYTHON3} get-pip.py --user

    #install virtualenv
    ${PIP3_AT}/bin/pip${PYTHON3} install --user virtualenv

    # install distribute
    ${PIP3_AT}/bin/pip${PYTHON3} install -U setuptools --user
fi

# enable pip
if [ ! `echo  $PATH | grep ${PIP2_AT}'/bin'` ]
then
  echo 'export PATH=$PATH:'${PIP2_AT}'/bin' >> ~/.bash_profile
  source ~/.bash_profile
fi

# install word2vec
if [ ! -e /vagrant/word2vec ] && [ -f /vagrant/Vagrantfile ]
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
${PIP2_AT}/bin/pip${PYTHON2} install --user mecab-python
${PIP3_AT}/bin/pip${PYTHON3} install --user mecab-python3

# install beautifulsoup
${PIP2_AT}/bin/pip${PYTHON2} install --user beautifulsoup4
${PIP3_AT}/bin/pip${PYTHON3} install --user beautifulsoup4

# install scikit-learn
${PIP2_AT}/bin/pip${PYTHON2} install --user scikit-learn
${PIP3_AT}/bin/pip${PYTHON3} install --user scikit-learn

# install matplotlib
${PIP2_AT}/bin/pip${PYTHON2} install --user matplotlib
${PIP3_AT}/bin/pip${PYTHON3} install --user matplotlib

# install scipy
${PIP2_AT}/bin/pip${PYTHON2} install --user scipy
${PIP3_AT}/bin/pip${PYTHON3} install --user scipy

# install sphinx
${PIP2_AT}/bin/pip${PYTHON2} install --user sphinx
${PIP3_AT}/bin/pip${PYTHON3} install --user sphinx

# install pydot
${PIP2_AT}/bin/pip${PYTHON2} install --user pydot
${PIP3_AT}/bin/pip${PYTHON3} install --user pydot

# install gensim
${PIP2_AT}/bin/pip${PYTHON2} install --user --upgrade gensim
${PIP3_AT}/bin/pip${PYTHON3} install --user --upgrade gensim

# install ruby & wp2txt
if [ ! -e ~/.rbenv ]
then
    # install rbenv
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
    echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
    source ~/.bash_profile

    # install ruby-build
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    cd ~/.rbenv/plugins/ruby-build
    sudo ./install.sh

    # install ruby
    rbenv install 2.3.1
    rbenv rehash
    rbenv global 2.3.1

    # instal wp2txt
    gem install wp2txt
fi

# add +x to sh file
if [ ! -e /vagrant/load ] && [ -f /vagrant/Vagrantfile ]
then
    find /vagrant/load -type f -print | xargs chmod 755
fi
