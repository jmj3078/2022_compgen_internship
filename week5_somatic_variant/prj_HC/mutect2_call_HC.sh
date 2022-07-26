#!/usr/bin/bash
#SBATCH -n 2
#SBATCH -N 1
#SBATCH -t 0-01:00
#SBATCH -p 48core
#SBATCH --mem=4G
#SBATCH -o ./log/mutect2_call_%j.out
#SBATCH -e ./log/mutect2_call_%j.err
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jmj3078@g.skku.edu

REF=/data/references/b37/human_g1k_v37_decoy.fasta

DISEASE_BAM=/scratch/2022_summer_internship/mjcho/week5_somatic_variant/bam/1C_HC.bam 
NORMAL_BAM=/scratch/2022_summer_internship/mjcho/week5_somatic_variant/bam/1F_HC.bam 
DISEASE_ID=1C_HC/1C_HC.bam
NORMAL_ID=1F_HC/1F_HC.bam
OUTPUT_ID=HC
BED=/scratch/2022_summer_internship/mjcho/week5_somatic_variant/bed/total.merged.bed
MIN_BQ=$1
ACTIVE_THRESHOLD=$2
TUMOR_LOD=$3
AF_NOTINRESOURCE=$4
NORMAL_LOD=$5
MIN_DANGLING_LENGTH=$6

gatk --java-options "-XX:+UseSerialGC -Xms4G -Xmx4G -Djava.io.tmpdir=./log/tmp/" Mutect2 \
-R $REF \
-I $DISEASE_BAM -I $NORMAL_BAM \
-tumor $DISEASE_ID \
-normal $NORMAL_ID \
-O $OUTPUT_ID.somatic.vcf.gz \
--native-pair-hmm-threads 2 -L $BED \
-pon /scratch/2022_summer_internship/mjcho/week6/PoN/pon.vcf.gz \

--min-base-quality-score $MIN_BQ \
-active-probability-threshold $ACTIVE_THRESHOLD \
--tumor-lod-to-emit $TUMOR_LOD \
--af-of-alleles-not-in-resource $AF_NOTINRESOURCE \
--base-quality-score-threshold $THRESHOLD_BQ \
--normal-lod $NORMAL_LOD \
--min-dangling-branch-length $MIN_DANGLING_LENGTH \
--disable-read-filter MappingQualityReadFilter \

gatk --java-options "-XX:+UseSerialGC -Xms1G -Xmx1G -Djava.io.tmpdir=./log/tmp/" FilterMutectCalls \
-R $REF \
-V $OUTPUT_ID.somatic.vcf.gz \
-O $OUTPUT_ID.somatic.filtered.vcf.gz \
-L $BED \
-f-score-beta $FILTER_FSCORE \


/opt/tools/annovar/convert2annovar.pl -format vcf4 HC.somatic.filtered.vcf.gz > $OUTPUT_ID.avinput


perl /opt/tools/annovar/table_annovar.pl \
$OUTPUT_ID.avinput /opt/tools/annovar/humandb/ \
-buildver hg19 -out $OUTPUT_ID.annovar -remove \
-protocol refGene,cytoBand,cosmic70,exac03,gnomad_genome,avsnp147,clinvar_20190305,HGMD.v4 \
-operation gx,r,f,f,f,f,f,f -polish \
-xref /opt/tools/annovar/example/gene_fullxref.txt \
