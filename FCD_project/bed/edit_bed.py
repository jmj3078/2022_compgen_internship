import pandas as pd

bed_path = input("Input bed file path : ")
output_path = input("Output bed file path : ")
df = pd.read_table(bed_path, sep='\t', names=['Chrom', 'start', 'end', 'w'])

df["Chrom"] = df["Chrom"].str.replace('chr', '')

df.to_csv(output_path, sep='\t', index = False, header = False)