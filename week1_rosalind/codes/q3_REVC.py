# -*- coding:utf-8 -*-

with open('../data/rosalind_revc.txt', 'r') as f:
    DNA = f.read()

rs = [0] * len(DNA)

i = 0
for bs in DNA:
    if bs == 'A':
        rs[i] = 'T'
    elif bs == 'C':
        rs[i] = 'G'
    elif bs == 'G':
        rs[i] = 'C'
    else:
        rs[i] = 'A'
    i += 1

rs.reverse()
rs_list = ''.join(rs)
print(rs_list)
f.close()
