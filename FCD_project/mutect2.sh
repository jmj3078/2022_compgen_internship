#!/usr/bin/bash
#SBATCH -J mutect2_pipeline
#SBATCH -n 2
#SBATCH -N 1
#SBATCH -t 2-00:00
#SBATCH -p 48core
#SBATCH --mem=4G
#SBATCH -o ./log/mutect2_call_%j.out
#SBATCH -e ./log/mutect2_call_%j.err
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jmj3078@g.skku.edu
date 

mkdir ./results

REF=/data/references/b37/human_g1k_v37_decoy.fasta
OUTPUT_DIR=./results

INPUT=$1
BED=$2

if [ ! -d $INPUT\_mutect2 ];then
    mkdir $INPUT\_mutect2
    echo "make $INPUT\_mutect2 directory"
else
    echo "$INPUT\_mutect2 directory already exist"
fi

#PoN 

gatk --java-options "-XX:+UseSerialGC -Xmx8G -Xmx8G -Djava.io.tmpdir=./log/tmp/" Mutect2 \
-R $REF \
-I ./bam/$ID\_Normal.sorted.RGadded.marked.realigned.fixed.recal.bam \
--max-mnp-distance 0 \
-O ./$INPUT\_mutect2/$ID.vcf.gz \

gatk --java-options "-XX:+UseSerialGC -Xms8G -Xmx8G -Djava.io.tmpdir=./log/tmp/" GenomicsDBImport \
-R $REF \
-L $BED \
--genomicsdb-workspace-path ./$INPUT\_mutect2/db_$ID \
-V ./$INPUT\_mutect2/$ID.vcf.gz \

gatk --java-options "-XX:+UseSerialGC -Xms8G -Xmx8G -Djava.io.tmpdir=./log/tmp/" CreateSomaticPanelOfNormals \
-R $REF \
-V gendb://pon_db \
-O ./$INPUT\_mutect2/$ID.pon.vcf.gz \

echo "PoN ..done"

# Mutect2

gatk --java-options "-XX:+UseSerialGC -Xms4G -Xmx4G -Djava.io.tmpdir=./log/tmp/" Mutect2 \
-R $REF \
-I ./bam/$ID\_Disease.sorted.RGadded.marked.realigned.fixed.recal.bam \
-I ./bam/$ID\_Normal.sorted.RGadded.marked.realigned.fixed.recal.bam \
-tumor $ID\_Disease \
-normal $ID\_Normal \
-O ./$INPUT\_mutect2/$ID.somatic.vcf.gz \
--native-pair-hmm-threads 2 \
-L $BED \
--panel-of-normals $ID.pon.vcf.gz \

echo "mutect2 calling ..done"

gatk --java-options "-XX:+UseSerialGC -Xms1G -Xmx1G -Djava.io.tmpdir=./log/tmp/" FilterMutectCalls \
-R $REF \
-V ./$INPUT\_mutect2/$ID.somatic.vcf.gz \
-O ./$INPUT\_mutect2/$ID.somatic.filtered.vcf.gz \
-L $BED \

echo "mutect2 filtering ..done"

/opt/tools/annovar/convert2annovar.pl -format vcf4 $OUTPUT_DIR\/$ID.somatic.filtered.vcf.gz > $OUTPUT_DIR\/$ID.avinput

perl /opt/tools/annovar/table_annovar.pl \
./$INPUT\_mutect2/$ID.avinput /opt/tools/annovar/humandb/ \
-buildver hg19 -out ./$INPUT\_mutect2/$ID.annovar -remove \
-protocol refGene,cytoBand,cosmic70,exac03,gnomad_genome,avsnp147,clinvar_20190305,HGMD.v4 \
-operation gx,r,f,f,f,f,f,f -polish \
-xref /opt/tools/annovar/example/gene_fullxref.txt \

echo "annovar annotation ..done"