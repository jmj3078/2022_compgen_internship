#!/usr/bin/bash
#SBATCH -n 4
#SBATCH -N 1
#SBATCH -t 0-24:00
#SBATCH -p 48core
#SBATCH --mem=8G
#SBATCH -o ./log/pon_%j.out
#SBATCH -e ./log/pon_%j.err
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jmj3078@g.skku.edu

REF=/data/references/b37/human_g1k_v37_decoy.fasta

gatk --java-options "-XX:+UseSerialGC -Xmx8G -Xmx8G -Djava.io.tmpdir=./log/tmp/" Mutect2 \
-R $REF \
-I /scratch/2022_summer_internship/mjcho/week5_somatic_variant/bam/1F_amp.bam \
--max-mnp-distance 0 \
-O amp_normal.vcf.gz \

gatk --java-options "-XX:+UseSerialGC -Xmx8G -Xmx8G -Djava.io.tmpdir=./log/tmp/" Mutect2 \
-R $REF \
-I /scratch/2022_summer_internship/mjcho/week5_somatic_variant/bam/1F_HC.bam \
--max-mnp-distance 0 \
-O HC_normal.vcf.gz \


