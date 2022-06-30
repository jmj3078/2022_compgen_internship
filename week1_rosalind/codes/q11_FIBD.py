# -*- coding:utf-8 -*-

def fibd(n, m):
    num_list = [0, 1]
    for i in range(1, n + 1, 1):
        if i < m:
            num_list.append(num_list[i] + num_list[i - 1])
        if i == m:
            num_list.append(num_list[i] + num_list[i - 1] - num_list[i - m + 1])
        if i > m:
            num_list.append(num_list[i] + num_list[i - 1] - num_list[i - m])

    return num_list[n]


if __name__ == "__main__":
    with open('../data/rosalind_fibd.txt', 'r') as f:
        n1, n2 = map(int, f.readline().strip().split(' '))
    print(fibd(n1, n2))

    f.close()
