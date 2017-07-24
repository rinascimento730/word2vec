#!/bin/sh
BASE="/vagrant"

# check mount /vagrant
if [ ! -e ${BASE}/Vagrantfile ]
then
	echo "ERROR: /vagrant is not mounted."
	exit 1
fi

# get wikipedia data
if [ ! -e ${BASE}/wikipedia/jawiki-latest-pages-articles.xml.bz2 ]
then
    mkdir ${BASE}/wikipedia
    cd ${BASE}/wikipedia
    curl -O https://dumps.wikimedia.org/jawiki/latest/jawiki-latest-pages-articles.xml.bz2
else
	echo "Nothing to do. in get wikipedia data"
fi

# check target dir
if [ ! -e ${BASE}/wikipedia/wp2txt ]
then
	mkdir ${BASE}/wikipedia/wp2txt
else
	echo "Nothing to do. check target dir"
fi

# make wp2txt file
WP2TXT=$(ls -1 /vagrant/wikipedia/wp2txt | wc -l)
if [ $WP2TXT -eq 0 ]
then
	wp2txt --input-file ${BASE}/wikipedia/jawiki-latest-pages-articles.xml.bz2 -o ${BASE}/wikipedia/wp2txt
else
	echo "Nothing to do. in make wp2txt file"
fi

# make wikipedia corpus
if [ ! -e ${BASE}/corpus/jawiki-wakati.txt ]
then
	cat ${BASE}/wikipedia/wp2txt/jawiki-latest-pages-articles.xml-*.txt | mecab -Owakati -b 11000000 > ${BASE}/corpus/jawiki-wakati.txt
else
	echo "Nothing to do. in make wikipedia corpus"
fi

# exec word2vec
if [ ! -e ${BASE}/word2vec/jawiki.bin ]
then
	time ${BASE}/word2vec/word2vec -train ${BASE}/corpus/jawiki-wakati.txt -output ${BASE}/word2vec/jawiki.bin -cbow 5 -threads 20 -size 200 -window 5 -negative 5 -hs 0 -sample 1e-4 -binary 1 -iter 15
else
	echo "Nothing to do. in exec word2vec"
fi
echo "Complete!!"





