import gzip
from Bio import SeqIO


def FASTQ_read_to_dict(file_name):
    fastq_dict = {'name': [], 'seq': [], 'description': []}
    if file_name.lower().endswith('.gz'):
        file = gzip.open(file_name, 'rt')
    else:
        file = open(file_name, 'rt')

    for read in SeqIO.parse(file, 'fastq'):
        fastq_dict['name'].append(read.name)
        fastq_dict['seq'].append(read.seq)
        fastq_dict['description'].append(read.description)

    return fastq_dict


if __name__ == "__main__":

    fastq = FASTQ_read_to_dict('sample_sub1000.fastq.gz')
    fastq_des = fastq['description']
    fastq['prob_err'] = []
    fastq['accuracy'] = []

    for des in fastq_des:
        prob_list = []
        acc_list = []
        des_split = [des[i] for i in range(len(des))]
        for v in des_split:
            prob = pow(10, -((ord(v) - 33) / 10))
            acc = 1 - prob
            prob_list.append(str(round(prob, 2)))
            acc_list.append(str(round(acc, 2)))

        fastq['prob_err'].append(' '.join(prob_list))
        fastq['accuracy'].append(' '.join(acc_list))
        
    print_str = '>name\n{}\n>seq\n{}\n>description \
                \n{}\n>prob_err\n{}\n>accuracy\n{}'
    for i in range(len(fastq['name'])):
        print(print_str.format(fastq['name'][i],
                               fastq['seq'][i],
                               fastq['description'][i],
                               fastq['prob_err'][i],
                               fastq['accuracy'][i]))
    