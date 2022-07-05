import pandas as pd
import re 



def dataframe_diff_by_col(df1, df2, which="both"):
    # Find rows which are different between two DataFrames have same columns
    
    comparison_df = df1.merge(df2, indicator=True, how='outer')
    if which is None:
        diff_df = comparison_df[comparison_df['_merge'] != 'both']
    else:
        diff_df = comparison_df[comparison_df['_merge'] == which]

    return diff_df



def get_annov_and_ans():
    path_annov = input(print("input file path of annov.txt file: "))
    path_ans = input(print("input file path of ans.txt file: "))

    annov = pd.read_table(path_annov)
    ans = pd.read_table(path_ans)

    # change format of ans, annov txt file to compare
    
    tmp = ans.Chrom.values.tolist()
    tmp = [re.sub(r'[^0-9]', '', x) for x in tmp]
    tmp = list(map(int, tmp))
    ans.Chrom = pd.Series(tmp)

    annov_comp = annov.iloc[:, [0,1,3,4]]
    annov_comp.columns = ans.columns 
    return annov_comp, ans
    
    
    
if __name__ == "__main__" :
    annov_comp, ans = get_annov_and_ans()
    diff = dataframe_diff_by_col(annov_comp, ans)
    
    PPV = len(diff)/len(annov_comp)
    TPR = len(diff)/len(ans)
    print(f"PPV: {round(PPV,3)}\nTPR: {round(TPR,3)} \
        \nFPV: {round(1-PPV,3)}\nFPR: {round(1-TPR,3)}")