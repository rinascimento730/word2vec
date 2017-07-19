# coding: utf-8
import csv
import MeCab
import re

tagger = MeCab.Tagger('-Owakati')
fo = file('../corpus/tweets-wakati.txt', 'w')
for line in csv.reader(file('resource/tweets.csv')):
	line = line[5]
	line = re.sub('https?://.*', '', line)
	fo.write(tagger.parse(line))
	print(line)
fo.close()