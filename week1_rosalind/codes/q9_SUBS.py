# -*- coding:utf-8 -*-

f = open('../data/rosalind_subs.txt', 'r')
lines = f.readlines()
data = lines[0].replace('\n', '')
motif = lines[1].replace('\n', '')

motif_length = len(motif)
idx = []

for i in range(len(data)):
    if data[i:i + motif_length] == motif:
        idx.append(i + 1)

print(' '.join(list(map(str, idx))))
f.close()
