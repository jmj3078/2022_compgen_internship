#!/usr/bin/bash
#SBATCH -n 2
#SBATCH -N 1
#SBATCH -t 0-02:00
#SBATCH -p 48core
#SBATCH --mem=4G
#SBATCH -o ./log/mutect2_call_%j.out
#SBATCH -e ./log/mutect2_call_%j.err
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jmj3078@g.skku.edu

REF=/data/references/b37/human_g1k_v37_decoy.fasta

ID=$1
BED=$2
OUTPUT_DIR=$3
PON=$4

gatk --java-options "-XX:+UseSerialGC -Xms4G -Xmx4G -Djava.io.tmpdir=./log/tmp/" Mutect2 \
-R $REF \
-I ../bam/$ID\_Disease.sorted.RGadded.marked.realigned.fixed.recal.bam \
-I ../bam/$ID\_Normal.sorted.RGadded.marked.realigned.fixed.recal.bam \
-tumor $ID\_Disease \
-normal $ID\_Normal \
-O $OUTPUT_DIR\/$ID.somatic.vcf.gz \
--native-pair-hmm-threads 2 \
-L $BED \
--panel-of-normals $PON \

echo "mutect2 calling ..done"

gatk --java-options "-XX:+UseSerialGC -Xms1G -Xmx1G -Djava.io.tmpdir=./log/tmp/" FilterMutectCalls \
-R $REF \
-V $OUTPUT_DIR\/$ID.somatic.vcf.gz \
-O $OUTPUT_DIR\/$ID.somatic.filtered.vcf.gz \
-L $BED \

echo "mutect2 filtering ..done"

/opt/tools/annovar/convert2annovar.pl -format vcf4 $OUTPUT_DIR\/$ID.somatic.filtered.vcf.gz > $OUTPUT_DIR\/$ID.avinput

perl /opt/tools/annovar/table_annovar.pl \
$OUTPUT_DIR\/$ID.avinput /opt/tools/annovar/humandb/ \
-buildver hg19 -out $OUTPUT_DIR\/$ID.annovar -remove \
-protocol refGene,cytoBand,cosmic70,exac03,gnomad_genome,avsnp147,clinvar_20190305,HGMD.v4 \
-operation gx,r,f,f,f,f,f,f -polish \
-xref /opt/tools/annovar/example/gene_fullxref.txt \

echo "annovar annotation ..done"