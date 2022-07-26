#!/usr/bin/bash
#SBATCH -n 2
#SBATCH -N 1
#SBATCH -t 1-00:00
#SBATCH -p 48core
#SBATCH --mem=16G
#SBATCH -o ./log/strelka_%j.out
#SBATCH -e ./log/strelka_%j.err
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jmj3078@g.skku.edu

date

REF=/data/references/b37/human_g1k_v37_decoy.fasta
INPUT=$1
BED=$2

if [ ! -d $INPUT\_strelka ];then
    mkdir $INPUT\_strelka
    echo "make $INPUT\_strelka directory"
else
    echo "$INPUT\_strelka directory already exist"
fi

/opt/biogrids/x86_64-linux/strelka/2.9.2/bin/configureStrelkaSomaticWorkflow.py \
--normalBam ./bam/$INPUT\_Normal.sorted.RGadded.marked.realigned.fixed.recal.bam \
--tumorBam ./bam/$INPUT\_Disease.sorted.RGadded.marked.realigned.fixed.recal.bam \
--referenceFasta $REF \
--callRegions $BED \
--runDir ./$INPUT\_strelka

# run.sh
/usr/bin/python ./$INPUT\_strelka/runWorkflow.py -m local

rename somatic $INPUT ./$INPUT\_strelka/results/variants/somatic*

#snvs: make avinput file
/opt/tools/annovar/convert2annovar.pl -format vcf4old ./$INPUT\_strelka/results/variants/$INPUT.snvs.vcf.gz > ./$INPUT\_strelka/results/$INPUT.snvs.avinput

#indels: make avinput file
/opt/tools/annovar/convert2annovar.pl -format vcf4old ./$INPUT\_strelka/results/variants/$INPUT.indels.vcf.gz > ./$INPUT\_strelka/results/$INPUT.indels.avinput

echo="finish strelka"

#annovar: annotation

#snvs
perl /opt/tools/annovar/table_annovar.pl \
./$INPUT\_strelka/results/$INPUT.snvs.avinput /opt/tools/annovar/humandb/ \
-buildver hg19 -out ./$INPUT\_strelka/results/$INPUT.snvs.annovar -remove \
-protocol refGene,cytoBand,cosmic70,exac03,gnomad_genome,avsnp147,clinvar_20190305,HGMD.v4 \
-operation gx,r,f,f,f,f,f,f -polish \
-xref /opt/tools/annovar/example/gene_fullxref.txt


#indels
perl /opt/tools/annovar/table_annovar.pl \
./$INPUT\_strelka/results/$INPUT.indels.avinput /opt/tools/annovar/humandb/ \
-buildver hg19 -out ./$INPUT\_strelka/results/$INPUT.indels.annovar -remove \
-protocol refGene,cytoBand,cosmic70,exac03,gnomad_genome,avsnp147,clinvar_20190305,HGMD.v4 \
-operation gx,r,f,f,f,f,f,f -polish \
-xref /opt/tools/annovar/example/gene_fullxref.txt

echo="finish annotation"

#finish
date

