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

DISEASE_BAM=$1
NORMAL_BAM=$2
DISEASE_ID=$3
NORMAL_ID=$4
OUTPUT_ID=$5
BED=$6

gatk --java-options "-XX:+UseSerialGC -Xms4G -Xmx4G -Djava.io.tmpdir=./log/" Mutect2 \
-R $REF \
-I $DISEASE_BAM -I $NORMAL_BAM \
-tumor $DISEASE_ID \
-normal $NORMAL_ID \
-O $OUTPUT_ID.somatic.vcf.gz \
--native-pair-hmm-threads 2 -L $BED
