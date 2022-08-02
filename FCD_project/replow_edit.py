import pandas as pd

name = input("input sample name : ")
path = f"./{name}_RePlow/out.snv.call"
replow = pd.read_table(path, low_memory=False)

edit = replow.iloc[:,[0,1,3,4]]
edit.insert(2, 'end', replow.pos)
edit.columns = ["chr", "start", "end", "ref", "alt"]
edit.to_csv(f"./{name}_RePlow/{name}_RePlow_edited.avinput", sep="\t", index=False)

edit_passed = replow[replow.Filter == "PASS"].iloc[:,[0,1,3,4]]
edit_passed.insert(2, 'end', replow.pos)
edit_passed.columns = ["chr", "start", "end", "ref", "alt"]
edit_passed.to_csv(f"./{name}_RePlow/{name}_RePlow_passed.avinput", sep="\t", index=False)
