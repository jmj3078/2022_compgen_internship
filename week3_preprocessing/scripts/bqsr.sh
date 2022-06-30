#!/usr/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 0-01:00
#SBATCH -p 48core
#SBATCH --mem=32G
#SBATCH -o ./log/localRealign_%j.out
#SBATCH -e ./log/localRealign_%j.err

date

IBAM=$1
OBAM=$2
REF=/data/references/b37/human_g1k_v37_decoy.fasta
dbSNP=/data/references/b37/dbsnp_147_b37_common_all_20160601.vcf

# 7.1) BaseRecalibrator
/programs/x86_64-linux/java/jdk1.8.0_144/bin/java -XX:+UseSerialGC -Xmx32g -Djava.io.tmpdir=./log/tmp -jar /programs/x86_64-linux/gatk/3.4-46/gatk/GenomeAnalysisTK.jar \
-T BaseRecalibrator \
-R $REF \
-I $IBAM \
--knownSites $dbSNP \
-o $IBAM.recal_data.grp

# 7.2) PrintReads
/programs/x86_64-linux/java/jdk1.8.0_144/bin/java -XX:+UseSerialGC -Xmx32g -Djava.io.tmpdir=./log/tmp -jar /programs/x86_64-linux/gatk/3.4-46/gatk/GenomeAnalysisTK.jar \
-T PrintReads \
-R $REF \
-I $IBAM \
-BQSR $IBAM.recal_data.grp \
-o $OBAM

date