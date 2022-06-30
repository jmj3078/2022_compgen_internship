# -*- coding:utf-8 -*-
import re
import requests as r
from Bio import SeqIO
from io import StringIO


# readlines()통해 얻어온 PASTA형식의 데이터 읽어서 name, seqs 분리하여 반환
def PASTA_readlines(lines):
    name = []
    temp = []
    seq = []
    for line in lines:
        if re.match('>', line):
            name.append(line.replace('>', '').strip())
            if temp:
                seq.append(''.join(temp))
                temp = []

        else:
            temp.append(line.strip())

    seq.append(''.join(temp))
    return name, seq


# seqs에서 각 염기서열을 요소로 하는 리스트 반환
def PASTA_splitted(seqs):
    return [list(seqs[i]) for i in range(len(seqs))]


# seqs와 k를 넣으면 Overlab_graphs(Ok)반환
def Overlab_graphs(seqs, name, k):
    heads = [seq[:k] for seq in seqs]
    tails = [seq[-k:] for seq in seqs]

    idx_list = []
    for i in range(len(tails)):
        for k in range(len(heads)):
            if heads[i] == tails[k] and i != k:
                idx_list.append([k, i])

    overlab_graph = []
    for idx in idx_list:
        overlab_names = [name[idx[0]], name[idx[1]]]
        overlab_graph.append(' '.join(overlab_names))

    return overlab_graph

# UniprotID 통해 record 불러오기
def UniID_to_record(cID):
    baseUrl = "http://www.uniprot.org/uniprot/"
    currentUrl = baseUrl + cID + ".fasta"
    response = r.post(currentUrl)
    cData = ''.join(response.text)

    Seq = StringIO(cData)
    for record in SeqIO.parse(Seq, 'fasta'):
        return record


# Uniprot ID를 입력하면 Nglycosylation motif 반환
def find_Nglycosylation_point(cID):
    motif_point = []
    pseq = str(UniID_to_record(cID).seq)
    p = re.compile(r'N[^P]([ST])[^P]')

    for j in range(len(pseq) - 3):
        if p.match(pseq[j:j + 4]):
            motif_point.append(str(j + 1))

    return motif_point