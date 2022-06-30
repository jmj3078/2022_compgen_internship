# -*- coding:utf-8 -*-
from PASTA import PASTA_readlines

def Overlab_graphs(seqs, k):
    heads = [seq[:k] for seq in seqs]
    tails = [seq[-k:] for seq in seqs]
    idx_list = []
    for i in range(len(heads)):
        for k in range(len(tails)):
            if heads[i] == tails[k] and i != k:
                idx_list.append([k, i])

    overlab_graph = []
    for idx in idx_list:
        overlab_names = [name[idx[0]], name[idx[1]]]
        overlab_graph.append(' '.join(overlab_names))

    return overlab_graph

if __name__ == "__main__":
    f = open('../data/rosalind_grph.txt', 'r')
    lines = f.readlines()

    [name, seqs] = PASTA_readlines(lines)
    overlab_graph = Overlab_graphs(seqs, 3)

    for output in overlab_graph:
        print(output)

    f.close()
