# -*- coding:utf-8 -*-

from PASTA import find_Nglycosylation_point

with open('../data/rosalind_mprt.txt', 'r') as f:
    lines = f.readlines()

for line in lines:
    cID = line.strip()
    motif_point = find_Nglycosylation_point(cID)
    if motif_point:
        print(cID)
        print(' '.join(motif_point))

f.close()

# def UniID_to_record(cID):
#     baseUrl = "http://www.uniprot.org/uniprot/"
#     currentUrl = baseUrl + cID + ".fasta"
#     response = r.post(currentUrl)
#     cData = ''.join(response.text)
#
#     Seq = StringIO(cData)
#     for record in SeqIO.parse(Seq, 'fasta'):
#         return record
#
#
# def find_Nglycosylation_point(cID):
#     motif_point = []
#     pseq = str(UniID_to_record(cID).seq)
#     p = re.compile(r'N[^P]([ST])[^P]')
#
#     for j in range(len(pseq) - 3):
#         if p.match(pseq[j:j + 4]):
#             motif_point.append(str(j + 1))
#
#     print(cID)
#     print(' '.join(motif_point))
#     return motif_point
