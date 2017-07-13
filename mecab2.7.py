#! /opt/local/bin/python2.7
# -*- coding: utf-8 -*-
import MeCab
mecab = MeCab.Tagger('-Ochasen')

print mecab.parse('祇園精舎の鐘の声諸行無常の響あり')