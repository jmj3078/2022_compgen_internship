# -*- coding:utf-8 -*-

f = open("../data/rosalind_hamm.txt", 'r')
lines = f.readlines()
count = sum(1 for a, b in zip(lines[0], lines[1]) if a != b)
print(count)
