# -*- coding:utf-8 -*-
from PASTA import PASTA_readlines

# from Bio import SeqIO
with open('../data/rosalind_lcsm.txt') as f:
    lines = f.readlines()
seq_name, seq_string = PASTA_readlines(lines)
seq = {seq_name[i]: seq_string[i] for i in range(len(seq_name))}


def shortest_seq(seq):
    min_len = 10000
    shortest_seq = ''
    for i in seq.keys():
        if len(seq[i]) < min_len:
            min_len = len(seq[i])
            shortest_seq = seq[i]
    return shortest_seq


def shared_motif(seq):
    s_seq = shortest_seq(seq)
    motif = set()
    for i in range(len(s_seq)):
        for j in range(i + 1, len(s_seq) + 1):
            motif.add(s_seq[i:j])

    for s in seq.values():
        update_motif = list(motif)
        for m in update_motif:
            if m not in s:
                motif.remove(m)
    n = 0
    longest_motif = ''
    for i in motif:
        if len(i) > n:
            longest_motif = i
            n = len(i)
    return longest_motif


# interpreter에서만 실행, import시 실행X
if __name__ == "__main__":
    with open('../data/rosalind_lcsm.txt') as f:
        lines = f.readlines()

    # seq_name = []
    # seq_string = []
    # with open('data/rosalind_lcsm.txt', 'r') as fa:
    #     for seq_record in SeqIO.parse(fa, 'fasta'):
    #         seq_name.append(str(seq_record.name))
    #         seq_string.append(str(seq_record.seq))
    seq_name, seq_string = PASTA_readlines(lines)

    seq = {seq_name[i]: seq_string[i] for i in range(len(seq_name))}
    print(shared_motif(seq))

    f.close()
