# -*- coding:utf-8 -*-
import operator as op
from functools import reduce

def nCr(n, r):
    if n < 1 or r < 0 or n < r:
        raise ValueError
    r = min(r, n - r)
    numerator = reduce(op.mul, range(n, n - r, -1), 1)
    denominator = reduce(op.mul, range(1, r + 1), 1)
    return numerator // denominator

if __name__ == "__main__":
    f = open('../data/rosalind_iprb.txt', 'r')
    r = f.read()
    ns = r.split()
    ns = list(map(int, ns))

    k, m, n = ns[0], ns[1], ns[2]

    deno = nCr(k + m + n, 2)
    nn = nCr(n, 2)
    mm = nCr(m, 2)
    dominant = 1 - ((m * n) / (deno * 2) + (nn) / (deno) + (mm) / (deno * 4))

    print(dominant)
