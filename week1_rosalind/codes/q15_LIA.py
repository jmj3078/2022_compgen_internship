# -*- coding:utf-8 -*-
import operator as op
from functools import reduce
import math


def nCr(n, r):
    if n < 1 or r < 0 or n < r:
        raise ValueError
    r = min(r, n - r)
    numerator = reduce(op.mul, range(n, n - r, -1), 1)
    denominator = reduce(op.mul, range(1, r + 1), 1)
    return numerator // denominator


def independent_alleles(k, n):
    p = 0
    cnt = pow(2, k)
    for i in range(n):
        p += nCr(cnt, i) * math.pow(0.25, i) * math.pow(0.75, cnt - i)
    return 1 - p


if __name__ == "__main__":
    with open('../data/rosalind_lia.txt', 'r') as f:
        nums_list = f.read().strip().split(' ')

    k, n = int(nums_list[0]), int(nums_list[1])
    print(independent_alleles(k, n))
    print(round(independent_alleles(k, n), 4))

    f.close()

