#!/usr/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 0-01:00
#SBATCH -p 48core
#SBATCH --mem=8G
#SBATCH -o ./log/markDup_%j.out
#SBATCH -e ./log/markDup_%j.err

# write your command
date

IBAM=$1
OBAM=$2

java -XX:+UseSerialGC -Xmx8g -Djava.io.tmpdir=./log/tmp -jar /programs/x86_64-linux/picard/2.26.10/bin/picard.jar MarkDuplicates \
INPUT=$IBAM \
OUTPUT=$OBAM \
METRICS_FILE=metrics \
CREATE_INDEX=true \
VALIDATION_STRINGENCY=LENIENT

date