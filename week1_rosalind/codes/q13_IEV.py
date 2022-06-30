# -*- coding:utf-8 -*-

with open('../data/rosalind_iev.txt') as f:
    nums_list = f.read().strip().split(' ')
nums = list(map(int, nums_list))
n_off = 0
for i in range(len(nums)):
    if i < 3:
        n_off += nums[i] * 2
    if i == 3:
        n_off += nums[i] * 3 / 2
    if i == 4:
        n_off += nums[i]
print(n_off)

f.close()
