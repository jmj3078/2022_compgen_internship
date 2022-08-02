#!/usr/bin/bash
#SBATCH -J annovar
#SBATCH -n 2
#SBATCH -N 1
#SBATCH -t 2-00:00
#SBATCH -p 48core
#SBATCH --mem=4G
#SBATCH -o ./log/annovar_%j.out
#SBATCH -e ./log/annovar_%j.err
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jmj3078@g.skku.edu

date 

INPUT=$1

perl /opt/tools/annovar/table_annovar.pl \
./$INPUT.mutect2.passed.vcf.edited.avinput /opt/tools/annovar/humandb/ \
-buildver hg19 -out ./$INPUT\.mutect.passed -remove \
-protocol refGene,cytoBand,cosmic70,exac03,gnomad_genome,avsnp147,clinvar_20190305,HGMD.v4 \
-operation gx,r,f,f,f,f,f,f -polish \
-xref /opt/tools/annovar/example/gene_fullxref.txt \

perl /opt/tools/annovar/table_annovar.pl \
 ./$INPUT.snvs.passed.vcf.edited.avinput /opt/tools/annovar/humandb/ \
-buildver hg19 -out ./$INPUT\.strelka.snvs.passed -remove \
-protocol refGene,cytoBand,cosmic70,exac03,gnomad_genome,avsnp147,clinvar_20190305,HGMD.v4 \
-operation gx,r,f,f,f,f,f,f -polish \
-xref /opt/tools/annovar/example/gene_fullxref.txt \

perl /opt/tools/annovar/table_annovar.pl \
../$INPUT.indels.passed.vcf.edited.avinput /opt/tools/annovar/humandb/ \
-buildver hg19 -out ./$INPUT\.strelka.indels.passed -remove \
-protocol refGene,cytoBand,cosmic70,exac03,gnomad_genome,avsnp147,clinvar_20190305,HGMD.v4 \
-operation gx,r,f,f,f,f,f,f -polish \
-xref /opt/tools/annovar/example/gene_fullxref.txt \

date
