#!/usr/bin/bash
#SBATCH -n 2
#SBATCH -N 1
#SBATCH -t 0-04:00
#SBATCH -p 48core
#SBATCH --mem=2G
#SBATCH -o ./log/gatk_gt_%j.out
#SBATCH -e ./log/gatk_gt_%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=your@email.address

REF=/data/references/b37/human_g1k_v37_decoy.fasta
dbSNP=/data/references/b37/dbsnp_147_b37_common_all_20160601.vcf
BED=$1

gatk --java-options "-XX:+UseSerialGC -Xmx2G -Xmx2G -Djava.io.tmpdir=./log/" GenomicsDBImport \
-V HC-1C.g.vcf.gz \
-V HC-1F.g.vcf.gz \
-V amp-1C.g.vcf.gz \
-V amp-1F.g.vcf.gz \
--genomicsdb-workspace-path merged_db \
-L $BED

gatk --java-options "-XX:+UseSerialGC -Xmx2G -Xmx2G -Djava.io.tmpdir=./log/" GenotypeGVCFs -R $REF \
-V gendb://merged_db \
-O merged.vcf.gz \
--dbsnp $dbSNP
