#!/usr/bin/bash
#SBATCH -n 2
#SBATCH -N 1
#SBATCH -t 0-04:00
#SBATCH -p 48core
#SBATCH --mem=2G
#SBATCH -o ./log/gatk_HC_%j.out
#SBATCH -e ./log/gatk_HC_%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=jmj3078@g.skku.edu

REF=/data/references/b37/human_g1k_v37_decoy.fasta
dbSNP=/data/references/b37/dbsnp_147_b37_common_all_20160601.vcf

BAM=$1
SAMPLE=$2
BED=$3

date

gatk --java-options "-XX:+UseSerialGC -Xms2G -Xmx2G -Djava.io.tmpdir=./log/" HaplotypeCaller -R $REF -I $BAM -O $SAMPLE.vcf.gz --dbsnp $dbSNP -ERC --native-pair-hmm-threads 2 -L $BED

date 