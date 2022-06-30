# -*- coding:utf-8 -*-

from codons import codons

f = open('../data/rosalind_prot.txt', 'r')
rna = f.read()

rna_codons = list(map(''.join, zip(*[iter(rna)] * 3)))
peptide = []

for codon in rna_codons:
    if codons[codon] == 'Stop':
        break
    else:
        peptide.append(codons[codon])

result = ''.join(peptide)
print(result)
