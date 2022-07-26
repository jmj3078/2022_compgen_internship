#!/usr/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 0-01:00
#SBATCH -p 48core
#SBATCH --mem=1G
#SBATCH -o ./log/mutect2_filter_%j.out
#SBATCH -e ./log/mutect2_filter_%j.err
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jmj3078@g.skku.edu

REF=/data/references/b37/human_g1k_v37_decoy.fasta

UNFILTERED_VCF=$1
FILTERED_VCF=$2
BED=$3

gatk --java-options "-XX:+UseSerialGC -Xms1G -Xmx1G -Djava.io.tmpdir=./log/" FilterMutectCalls \
-R $REF \
-V $UNFILTERED_VCF \
-O $FILTERED_VCF \
-L $BED