#!/usr/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 0-01:00
#SBATCH -p 48core
#SBATCH --mem=4G
#SBATCH -o ./log/addRG_%j.out
#SBATCH -e ./log/addRG_%j.err

# write your command
date

IBAM=$1
OBAM=$2
PROJECT=$3
PLATFORM=$4
SAMPLE=$5

java -XX:+UseSerialGC -Xmx4g -Djava.io.tmpdir=./log/tmp -jar /programs/x86_64-linux/picard/2.26.10/bin/picard.jar AddOrReplaceReadGroups \
INPUT=$IBAM \
OUTPUT=$OBAM \
SORT_ORDER=coordinate \
RGLB=$PROJECT \
RGPL=$PLATFORM \
RGPU=$PLATFORM \
RGSM=$SAMPLE \
CREATE_INDEX=true \
VALIDATION_STRINGENCY=LENIENT

date