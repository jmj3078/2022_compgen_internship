import pandas as pd
name = input("input sample name : ")
path = f"./{name}_varscan2/{name}"

varscan_indels = pd.read_table(path+".output.indel")
varscan_snvs = pd.read_table(path+".output.snp")

varscan_snvs_E = varscan_snvs[varscan_snvs["somatic_status"]=="Somatic"]
varscan_indels_E = varscan_indels[varscan_indels["somatic_status"]=="Somatic"]

varscan = pd.concat([varscan_snvs_E, varscan_indels_E])
varscan.to_csv(path+".varscan.csv", index=False, sep="\t")