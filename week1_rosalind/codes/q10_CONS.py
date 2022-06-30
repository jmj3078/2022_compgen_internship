# -*- coding:utf-8 -*-
import re
import numpy as np

f = open('../data/rosalind_cons.txt', 'r')
lines = f.readlines()

name = []
temp = []
seqs = []
for line in lines:
    if re.match('>', line):
        name.append(line.replace('>', '').strip())
        if temp:
            seqs.append(''.join(temp))
            temp = []

    else:
        temp.append(line.strip())

seqs.append(''.join(temp))

splited = [list(seqs[i]) for i in range(len(seqs))]
arr = np.array(splited)
nrow = arr.shape[1]
ncol = arr.shape[0]

arr_count = np.zeros([4, nrow])
marker = ['A', 'G', 'C', 'T']

for i in range(nrow):
    arr_count[0][i] = (arr[:, i] == marker[0]).sum()
    arr_count[1][i] = (arr[:, i] == marker[1]).sum()
    arr_count[2][i] = (arr[:, i] == marker[2]).sum()
    arr_count[3][i] = (arr[:, i] == marker[3]).sum()

idx = np.zeros([1, nrow])
consensus = []

for i in range(nrow):
    max = arr_count[:, i].max()
    consensus.append(marker[arr_count[:, i].tolist().index(max)])

print(''.join(consensus))
for i in range(4):
    count_result = list(map(int, arr_count[i, :].tolist()))
    count_result = list(map(str, count_result))
    print('{0} : {1}'.format(marker[i], ' '.join(count_result)))

f.close()
