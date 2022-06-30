# -*- coding:utf-8 -*-

with open('../data/rosalind_dna.txt', 'r') as f:
    DNA = f.read()

A = 0
G = 0
C = 0
T = 0
for base in DNA:
    if base == 'A':
        A += 1
    elif base == 'C':
        C += 1
    elif base == 'G':
        G += 1
    else:
        T += 1
print('A:{0}, C:{1}, G:{2}, T:{3}'.format(A, C, G, T))

f.close()
