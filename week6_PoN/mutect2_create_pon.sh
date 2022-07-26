#!/usr/bin/bash
#SBATCH -n 4
#SBATCH -N 1
#SBATCH -t 0-24:00
#SBATCH -p 48core
#SBATCH --mem=8G
#SBATCH -o ./log/create_pon_%j.out
#SBATCH -e ./log/create_pon_%j.err
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jmj3078@g.skku.edu
REF=/data/references/b37/human_g1k_v37_decoy.fasta

gatk --java-options "-XX:+UseSerialGC -Xms8G -Xmx8G -Djava.io.tmpdir=./log/tmp/" CreateSomaticPanelOfNormals \
-R $REF \
-V gendb://pon_db \
-O pon.vcf.gz