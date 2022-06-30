#!/usr/bin/bash
#SBATCH -n 8
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

# step1. To create a table of possible indels
/programs/x86_64-linux/java/jdk1.8.0_144/bin/java -XX:+UseSerialGC -Xmx32g -Djava.io.tmpdir=./log/tmp -jar /programs/x86_64-linux/gatk/3.4-46/gatk/GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-R $REF \
-o $IBAM.list \
-I $IBAM \
-dt NONE \
-nt 8

# step2. To realign reads around indels targets
/programs/x86_64-linux/java/jdk1.8.0_144/bin/java -XX:+UseSerialGC -Xmx32g -Djava.io.tmpdir=./log/tmp -jar /programs/x86_64-linux/gatk/3.4-46/gatk/GenomeAnalysisTK.jar \
-I $IBAM \
-R $REF \
-T IndelRealigner \
-targetIntervals $IBAM.list \
-o $OBAM \
--maxReadsForRealignment 300000

date