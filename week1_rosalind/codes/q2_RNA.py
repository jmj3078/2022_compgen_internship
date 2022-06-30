# -*- coding:utf-8 -*-

with open('../data/rosalind_RNA.txt', 'r') as f:
    DNA = f.read()

RNA = DNA.replace("T", "U")
print(RNA)

f.close()
