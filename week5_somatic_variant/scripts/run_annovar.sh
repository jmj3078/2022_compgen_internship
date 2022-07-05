#!/usr/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 0-01:00
#SBATCH -p 48core
#SBATCH --mem=1G
#SBATCH -o ./log/annovar_%j.out
#SBATCH -e ./log/annovar_%j.err
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jmj3078@g.skku.edu

INPUT=$1

perl /opt/tools/annovar/table_annovar.pl \
$INPUT\.avinput /opt/tools/annovar/humandb/ \
-buildver hg19 -out $INPUT\.annovar -remove \
-protocol refGene,cytoBand,cosmic70,exac03,gnomad_genome,avsnp147,clinvar_20190305,HGMD.v4 \
-operation gx,r,f,f,f,f,f,f -polish \
-xref /opt/tools/annovar/example/gene_fullxref.txt
