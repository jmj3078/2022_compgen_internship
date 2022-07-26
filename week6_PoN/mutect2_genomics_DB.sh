#!/usr/bin/bash
#SBATCH -n 4
#SBATCH -N 1
#SBATCH -t 0-24:00
#SBATCH -p 48core
#SBATCH --mem=8G
#SBATCH -o ./log/genomics_DB_%j.out
#SBATCH -e ./log/genomics_DB_%j.err
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jmj3078@g.skku.edu

REF=/data/references/b37/human_g1k_v37_decoy.fasta

gatk --java-options "-XX:+UseSerialGC -Xms8G -Xmx8G -Djava.io.tmpdir=./log/tmp/" GenomicsDBImport \
-R $REF \
-L /scratch/2022_summer_internship/mjcho/week5_somatic_variant/bed/total.merged.bed \
--genomicsdb-workspace-path /scratch/2022_summer_internship/mjcho/PoN/pon_db \
-V ./amp_normal.vcf.gz \
-V ./HC_normal.vcf.gz \

