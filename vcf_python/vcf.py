import os
import gzip
import pandas as pd
import io
from Bio import Entrez


# load vcf file or vcf.gz file and get names of variants
def vcf_names(vcf_path):
    if os.path.splitext(vcf_path)[-1] == ".gz":
        f = gzip.open(vcf_path, "rt")

    else:
        f = open(vcf_path, "rt")

    for lines in f:
        if lines.startswith("#CHROM"):
            vcf_names = [l for l in lines.split("\t")]
        break
    f.close()
    return vcf_names



# load vcf file or vcf.gz file and convert it csv and DataFrame format.
def vcf_to_DataFrame(vcf_path):
    if os.path.splitext(vcf_path)[-1] == ".gz":
        with gzip.open(vcf_path, "rt") as f:
            lines = [l for l in f if not l.startswith("##")]
    else:
        with open(vcf_path, "rt") as f:
            lines = [l for l in f if not l.startswith("##")]

    dataframe = pd.read_csv(
        io.StringIO(''.join(lines)),
        dtype={'#CHROM': str, "POS": int, "ID": str, "REF": str, "ALT": str,
               "QUAL": str, "FILTER": str, "INFO": str},
        sep="\t").rename(columns={"#CHROM": "CHROM"})
    return dataframe



# convert vcf variants ID to GENE name using Bio.Entrez Package.
# You can use this code changing Parsing method or indexs of record.
def varID_to_gene(Idlist, entrez_email):
    Entrez.email = "jmj3078@g.skku.edu"
    Entrez.tool = "MyLocalScript"
    result = []
    for Id in Idlist:
        if Id != ".":
            handle = Entrez.esearch(db="snp", term=Id)
            record = Entrez.read(handle)
            ncbi_Idlist = record["IdList"]

            handle = Entrez.efetch(
                db="snp", id=ncbi_Idlist[0], rettype="docsum", retmode="xml")
            record = Entrez.read(handle)
            result.append(record['DocumentSummarySet']
                          ['DocumentSummary'][0]['GENES'][0]['NAME'])

        else:
            result.append(".")
    return result



if __name__ == "__main__":
    vcf_path = "./samples/snps_filtered.vcf.gz"
    entrez_email = "jmj3078@g.skku.edu"
    df = vcf_to_DataFrame(vcf_path)
    IdList = df['ID'].tolist()

    SNP_genes = varID_to_gene(IdList, entrez_email)
    df = vcf_to_DataFrame(vcf_path)

    s = pd.Series(SNP_genes, name='GENE')
    df = pd.concat([df, s], axis=1)
    df.to_csv(vcf_path + '.csv', index=False)
