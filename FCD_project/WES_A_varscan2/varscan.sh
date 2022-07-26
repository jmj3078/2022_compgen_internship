#!/usr/bin/bash
#SBATCH -n 2
#SBATCH -N 1
#SBATCH -t 1-00:00
#SBATCH -p 48core
#SBATCH --mem=16G
#SBATCH -o ./log/varscan_%j.out
#SBATCH -e ./log/varscan_%j.err
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jmj3078@g.skku.edu

date

REF=/data/references/b37/human_g1k_v37_decoy.fasta

INPUT=$1
# TUMOR_PURITY=$2
# P_VALUE=$3
# SOMATIC_P_VALUE=$4

samtools mpileup -f $REF ../bam/$INPUT\_Disease.sorted.RGadded.marked.realigned.fixed.recal.bam > ../bam/$INPUT\_Disease.mpileup 
samtools mpileup -f $REF ../bam/$INPUT\_Normal.sorted.RGadded.marked.realigned.fixed.recal.bam > ../bam/$INPUT\_Normal.mpileup

java -jar /opt/biogrids/x86_64-linux/varscan/2.4.4/bin/varscan.jar somatic \
../bam/$INPUT\_Normal.mpileup \
../bam/$INPUT\_Disease.mpileup \
--output-snp $INPUT.output.snp \
--output-indel $INPUT.output.indel \
# --tumor-purity $TUMOR_PURITY \
# --p-value $P_VALUE \
# --somatic-p-value $SOMATIC_P_VALUE \
