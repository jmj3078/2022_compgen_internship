#!/usr/bin/bash
#SBATCH -J BQ_Recal_%j
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 14-00:00
#SBATCH -p 48core
#SBATCH --mem=17G
#SBATCH -o ./log/BQ_Recal_%j.out
#SBATCH -e ./log/BQ_Recal_%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=jmj3078@g.skku.edu

REF=/data/references/b37/human_g1k_v37_decoy.fasta
BAM=$1

# 7.1) BaseRecalibrator
/programs/x86_64-linux/java/jdk1.8.0_144/bin/java -XX:+UseSerialGC -Xmx16g -Djava.io.tmpdir=./log/tmp -jar /programs/x86_64-linux/gatk/3.4-46/gatk/GenomeAnalysisTK.jar \
-T BaseRecalibrator \
-R $REF \
-I $BAM.sorted.RGadded.marked.realigned.fixed.bam \
--knownSites $dbSNP \
-o $BAM.recal_data.grp

# 7.2) PrintReads
/programs/x86_64-linux/java/jdk1.8.0_144/bin/java -XX:+UseSerialGC -Xmx16g -Djava.io.tmpdir=./log/tmp -jar /programs/x86_64-linux/gatk/3.4-46/gatk/GenomeAnalysisTK.jar \
-T PrintReads \
-R $REF \
-I $BAM.sorted.RGadded.marked.realigned.fixed.bam \
-BQSR $BAM.recal_data.grp \
-o $BAM.sorted.RGadded.marked.realigend.fixed.recal.bam

date
echo "Base Quality Score Recalibration ..done"
echo "Job done"