# -*- coding:utf-8 -*-
from PASTA import PASTA_readlines
f = open('../data/rosalind_gc.txt', 'r')
lines = f.readlines()

name = []
temp = []
seq = []
GC = []

name, seq = PASTA_readlines(lines)

for v in seq:
    GC.append((v.count('G') + v.count('C')) / len(v) * 100)

max_idx = GC.index(max(GC))
print(name[max_idx])
print('{}%'.format(round(GC[max_idx], 6)))

f.close()
