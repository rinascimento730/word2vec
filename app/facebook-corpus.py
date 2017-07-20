# coding: utf-8
import bs4
import csv
import MeCab
import re

tagger = MeCab.Tagger('-Owakati')
fo = file('../corpus/facebook-wakati.txt', 'w')

soup = bs4.BeautifulSoup(file('resource/facebook/wall.html').read())
for div in soup.find_all('div', 'comment'):
	if 'Satoshi Fujinaga updated his status.' in div.parent.text:
		line = div.text
		line = ' '.join(line.split('\n'))
		line = re.sub('https?://.*', '', line)
		fo.write(tagger.parse(line.encode('utf-8')))

soup = bs4.BeautifulSoup(file('resource/facebook/message.html').read())
for div in soup.find_all('div', 'thread'):
	for p in div.find_all('p')
		line = p.text
		line = ' '.join(line.split('\n'))
		line = re.sub('https?://.*', '', line)
		fo.write(tagger.parse(line.encode('utf-8')))

fo.close()
