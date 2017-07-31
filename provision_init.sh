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
PIP_AT="/opt/local"
MECAB_AT="/opt/local"
JUMAN_AT="/opt/local"


# yum upgrade
sudo yum -y upgrade

# install git
sudo yum -y install git

# install dev tools
sudo yum -y groupinstall "Development tools"
sudo yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel scl-utils

# install boost-devel
sudo yum -y install http://repo.enetres.net/x86_64/boost-devel-1.59.0-1.x86_64.rpm

# add Devtoolset-3 Repo
if [ ! -e /etc/yum.repos.d/rhscl-devtoolset-3-epel-6.repo ]
then
    cd  /etc/yum.repos.d/
    sudo wget --no-check-certificate https://copr-fe.cloud.fedoraproject.org/coprs/rhscl/devtoolset-3/repo/epel-6/rhscl-devtoolset-3-epel-6.repo
    sudo yum -y install devtoolset-3-gcc devtoolset-3-binutils
    sudo yum -y install devtoolset-3-gcc-c++ devtoolset-3-gcc-gfortran

    #scl enable devtoolset-3 bash
    echo 'source /opt/rh/devtoolset-3/enable' >> ~/.bash_profile
fi

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
    sudo ${PYTHON_AT}/bin/python${PYTHON2} get-pip.py

    #install virtualenv
    sudo ${PIP_AT}/bin/pip${PYTHON2} install virtualenv

    # install distribute
    sudo ${PIP_AT}/bin/pip${PYTHON2} install -U setuptools
fi

# install pip3
if [ ! -e ${PIP_AT}/bin/pip${PYTHON3} ]
then
	cd ${SRC_TO}
    # install pip
    sudo curl -O https://bootstrap.pypa.io/get-pip.py
    sudo ${PYTHON_AT}/bin/python${PYTHON3} get-pip.py

    #install virtualenv
    sudo ${PIP_AT}/bin/pip${PYTHON3} install virtualenv

    # install distribute
    sudo ${PIP_AT}/bin/pip${PYTHON3} install -U setuptools
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
if [ ! -e ${MECAB_AT}/bin/mecab ]
then
    # install gcc-c++
	sudo yum -y install gcc-c++

    # install mecab
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

# install JUMAN++
if [ ! -e ${JUMAN_AT}/bin/jumanpp ]
then
    cd ${SRC_TO}
    sudo curl -O http://lotus.kuee.kyoto-u.ac.jp/nl-resource/jumanpp/jumanpp-1.01.tar.xz
    sudo tar xJvf jumanpp-1.01.tar.xz
    cd jumanpp-1.01/
    sudo ./configure --prefix=${JUMAN_AT}
    sudo make
    sudo make install
fi

# install JUMAN
if [ ! -e ${JUMAN_AT}/bin/juman ]
then
    cd ${SRC_TO}
    sudo curl -O http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/juman/juman-7.01.tar.bz2
    sudo tar jxvf juman-7.01.tar.bz2
    cd juman-7.01
    sudo ./configure --prefix=${JUMAN_AT}
    sudo make
    sudo make install
fi

# install KNP
if [ ! -e ${JUMAN_AT}/bin/knp ]
then
    cd ${SRC_TO}
    sudo wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/knp/knp-4.17.tar.bz2
    sudo tar jxvf knp-4.17.tar.bz2
    cd knp-4.17
    sudo ./configure --prefix=${JUMAN_AT}
    sudo make
    sudo make install
fi

# install mecab-python
sudo ${PIP_AT}/bin/pip${PYTHON2} install mecab-python
sudo ${PIP_AT}/bin/pip${PYTHON3} install mecab-python3

# install beautifulsoup
sudo ${PIP_AT}/bin/pip${PYTHON2} install beautifulsoup4
sudo ${PIP_AT}/bin/pip${PYTHON3} install beautifulsoup4

# install scikit-learn
sudo ${PIP_AT}/bin/pip${PYTHON2} install scikit-learn
sudo ${PIP_AT}/bin/pip${PYTHON3} install scikit-learn

# install matplotlib
sudo ${PIP_AT}/bin/pip${PYTHON2} install matplotlib
sudo ${PIP_AT}/bin/pip${PYTHON3} install matplotlib

# install scipy
sudo ${PIP_AT}/bin/pip${PYTHON2} install scipy
sudo ${PIP_AT}/bin/pip${PYTHON3} install scipy

# install sphinx
sudo ${PIP_AT}/bin/pip${PYTHON2} install sphinx
sudo ${PIP_AT}/bin/pip${PYTHON3} install sphinx

# install pydot
sudo ${PIP_AT}/bin/pip${PYTHON2} install pydot
sudo ${PIP_AT}/bin/pip${PYTHON3} install pydot

# install gensim
sudo ${PIP_AT}/bin/pip${PYTHON2} install --upgrade gensim
sudo ${PIP_AT}/bin/pip${PYTHON3} install --upgrade gensim

# install PyKNP
if [ ! -e ${SRC_TO}/pyknp-0.3 ]
then
    cd ${SRC_TO}
    sudo wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/knp/pyknp-0.3.tar.gz
    sudo tar xvf pyknp-0.3.tar.gz
    cd pyknp-0.3
    sudo ${PYTHON_AT}/bin/python${PYTHON2} setup.py install
    sudo ${PYTHON_AT}/bin/python${PYTHON3} setup.py install
fi

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
