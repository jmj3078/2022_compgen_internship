#!/usr/bin/bash
#SBATCH -J pon_mutect2
#SBATCH -n 4
#SBATCH -N 1
#SBATCH -t 0-24:00
#SBATCH -p 48core
#SBATCH --mem=8G
#SBATCH -o ./log/pon_%j.out
#SBATCH -e ./log/pon_%j.err
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jmj3078@g.skku.edu

NORMAL_BAM=$1
OUTPUT_NAME=$2
BED=$3
WORKSPACE_PATH=$4

REF=/data/references/b37/human_g1k_v37_decoy.fasta

gatk --java-options "-XX:+UseSerialGC -Xmx8G -Xmx8G -Djava.io.tmpdir=./log/tmp/" Mutect2 \
-R $REF \
-I $NORMAL_BAM \
--max-mnp-distance 0 \
-O $OUTPUT_NAME.vcf.gz \

gatk --java-options "-XX:+UseSerialGC -Xms8G -Xmx8G -Djava.io.tmpdir=./log/tmp/" GenomicsDBImport \
-R $REF \
-L $BED \
--genomicsdb-workspace-path $WORKSPACE_PATH \
-V $OUTPUT_NAME.vcf.gz \

REF=/data/references/b37/human_g1k_v37_decoy.fasta

gatk --java-options "-XX:+UseSerialGC -Xms8G -Xmx8G -Djava.io.tmpdir=./log/tmp/" CreateSomaticPanelOfNormals \
-R $REF \
-V gendb://pon_db \
-O $OUTPUT_NAME.pon.vcf.gz
