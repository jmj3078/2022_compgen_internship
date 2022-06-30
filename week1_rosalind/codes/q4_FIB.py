# -*- coding:utf-8 -*-
def fibnum(n, k):
    if n not in range(1, 40) or k not in range(1, 5):
        raise ValueError('n must be in (1,40) and k must be in (1,5)')
    elif n == 1 or n == 2:
        return 1
    else:
        return fibnum(n - 1, k) + fibnum(n - 2, k) * k

if __name__ == "__main__":
    with open('../data/rosalind_fib.txt', 'r') as f:
        n, k = map(int, f.readline().strip().split(' '))
    print(fibnum(n, k))
