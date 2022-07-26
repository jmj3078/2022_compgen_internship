#!/usr/bin/bash
#SBATCH -J HC_GATK_%j
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 14-00:00
#SBATCH -p 48core
#SBATCH --mem=17G
#SBATCH -o ./log/HC_GATK_%j.out
#SBATCH -e ./log/HC_GATK_%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=jmj3078@g.skku.edu
#args

BAM=$1
PROJECT=$2
PLATFORM=$3
FASTQ1=$4
FASTQ2=$5

#fixing reference, annotation
REF=/data/references/b37/human_g1k_v37_decoy.fasta
dbSNP=/data/references/b37/dbsnp_147_b37_common_all_20160601.vcf

#convert fastq to bam

bwa mem -t 4 $REF $FASTQ1 $FASTQ2 | samtools view -b -o $BAM.bam

#1.Sortsam

java -XX:+UseSerialGC -Xmx8g -Djava.io.tmpdir=./log/tmp -jar /programs/x86_64-linux/picard/2.26.10/bin/picard.jar SortSam \
SO=coordinate \
INPUT=$BAM.bam \
OUTPUT=$BAM.sorted.bam \
VALIDATION_STRINGENCY=LENIENT \
CREATE_INDEX=true

date
echo "SortSam ..done"

#2. addRG

java -XX:+UseSerialGC -Xmx8g -Djava.io.tmpdir=./log/tmp -jar /programs/x86_64-linux/picard/2.26.10/bin/picard.jar AddOrReplaceReadGroups \
INPUT=$BAM.sorted.bam \
OUTPUT=$BAM.sorted.RGadded.bam \
SORT_ORDER=coordinate \
RGLB=$PROJECT \
RGPL=$PLATFORM \
RGPU=$PLATFORM \
RGSM=$BAM \
CREATE_INDEX=true \
VALIDATION_STRINGENCY=LENIENT

date
echo "add read groups ..done"

#3. mark duplicated
java -XX:+UseSerialGC -Xmx8g -Djava.io.tmpdir=./log/tmp -jar /programs/x86_64-linux/picard/2.26.10/bin/picard.jar MarkDuplicates \
INPUT=$BAM.sorted.RGadded.bam \
OUTPUT=$BAM.sorted.RGadded.marked.bam \
METRICS_FILE=metrics \
CREATE_INDEX=true \
VALIDATION_STRINGENCY=LENIENT

date
echo "mark duplicates ..done"

#local realign

/programs/x86_64-linux/java/jdk1.8.0_144/bin/java -XX:+UseSerialGC -Xmx16g -Djava.io.tmpdir=./log/tmp -jar /programs/x86_64-linux/gatk/3.4-46/gatk/GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-R $REF \
-o $BAM.sorted.RGadded.marked.bam.list \
-I $BAM.sorted.RGadded.marked.bam \
-dt NONE \
-nt 8

/programs/x86_64-linux/java/jdk1.8.0_144/bin/java -XX:+UseSerialGC -Xmx16g -Djava.io.tmpdir=./log/tmp -jar /programs/x86_64-linux/gatk/3.4-46/gatk/GenomeAnalysisTK.jar \
-I $BAM.sorted.RGadded.marked.bam \
-R $REF \
-T IndelRealigner \
-targetIntervals $BAM.sorted.RGadded.marked.bam.list \
-o $BAM.sorted.RGadded.marked.realigned.bam \
--maxReadsForRealignment 300000

date
echo "local realignment ..done"

java -XX:+UseSerialGC -Xmx16g -Djava.io.tmpdir=./log/tmp -jar /programs/x86_64-linux/picard/2.26.10/bin/picard.jar FixMateInformation \
INPUT=$BAM.sorted.RGadded.marked.realigned.bam \
OUTPUT=$BAM.sorted.RGadded.marked.realigned.fixed.bam \
SO=coordinate \
VALIDATION_STRINGENCY=LENIENT \
CREATE_INDEX=true

date
echo "fix mate information ..done"

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
-o $BAM.sorted.RGadded.marked.realigned.fixed.recal.bam

date
echo "Base Quality Score Recalibration ..done"
echo "Job done"