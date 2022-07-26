#!/usr/bin/bash
#SBATCH -J replow_pipeline
#SBATCH -n 2
#SBATCH -N 1
#SBATCH -t 2-00:00
#SBATCH -p 48core
#SBATCH --mem=4G
#SBATCH -o ./log/RePlow_%j.out
#SBATCH -e ./log/RePlow_%j.err
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jmj3078@g.skku.edu
date 

REF=/data/references/b37/human_g1k_v37_decoy.fasta

INPUT=$1
BED=$2
DISEASE_BAM=./bam/$INPUT\_Disease.sorted.RGadded.marked.realigned.fixed.recal.bam 
NORMAL_BAM=./bam/$INPUT\_Normal.sorted.RGadded.marked.realigned.fixed.recal.bam 
RSCRIPT=/opt/biogrids/x86_64-linux/system/biogrids_bin/Rscript
OUTPUT_DIR=./$INPUT\_RePlow
LABEL=out

if [ ! -d $INPUT\_RePlow ];then
    mkdir $INPUT\_RePlow
    echo "make $INPUT\_RePlow directory"
else
    echo "$INPUT\_RePlow directory already exist"
fi

java -jar /scratch/2022_summer_internship/mjcho/replow-code/RePlow-1.1.0.jar \
-r $REF \
-b $DISEASE_BAM \
-N $NORMAL_BAM \
-T $BED \
-R $RSCRIPT \
-o $OUTPUT_DIR \
-L $LABEL
