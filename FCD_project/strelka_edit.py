import pandas as pd
name = input("input sample name : ")
path = f"./{name}_strelka/results/{name}"

strel_1 = pd.read_table(f"./{name}_strelka/results/{name}.snvs.annovar.hg19_multianno.txt")
strel_2 = pd.read_table(f"./{name}_strelka/results/{name}.indels.annovar.hg19_multianno.txt")

strel = pd.concat([strel_1, strel_2])
strel.to_csv(f"./{name}_strelka/results/{name}_strelka2_merged.txt", sep="\t", index = False)
