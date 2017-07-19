#!/bin/sh
BASE="/vagrant"
time ${BASE}/word2vec/word2vec -train ${BASE}/corpus/tweets-wakati.txt -output ${BASE}/word2vec/tweet.bin -cbow 0 - size 200 -window 5 -negative 0 -hs 1 -sample 1e-3 -binary 1