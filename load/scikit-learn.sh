#!/bin/sh
BASE="/vagrant"
SCIKIT=${BASE}"/scikit"

# check mount /vagrant
if [ ! -e ${BASE}/Vagrantfile ]
then
	echo "ERROR: /vagrant is not mounted."
	exit 1
fi

# check target dir
if [ ! -e ${SCIKIT} ]
then
	mkdir ${SCIKIT}
else
	echo "Nothing to do. check target dir"
fi

# make mycorpus file
if [ ! -e ${SCIKIT}/mycorpus ]
then
	cd ${SCIKIT}
	git clone https://github.com/nishio/mycorpus.git
else
	echo "Nothing to do. in make scikit corpus"
fi

# make mycorpus file
if [ ! -e ${SCIKIT}/mycorpus/word2vec_boostpython ]
then
	cd ${SCIKIT}/mycorpus
	git clone https://github.com/nishio/word2vec_boostpython.git

	# get font
	curl -O http://dl.ipafont.ipa.go.jp/IPAfont/IPAGTTC00303.zip
	unzip IPAGTTC00303.zip
	mv IPAGTTC00303/ipag.ttc ipag.ttc
	rm -R IPAGTTC00303*

	cd ${SCIKIT}/mycorpus/word2vec_boostpython
	# notice:before exec setup.py change to iclude_dir "include_dirs = ['/home/vagrant/.local/lib/python2.7/site-packages/numpy/core/include/'],"
	python2.7 setup.py install --user
	#python3.6 setup.py install --user
else
	echo "Nothing to do. in make scikit corpus"
fi

