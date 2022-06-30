#!/usr/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 0-01:00
#SBATCH -p 48core
#SBATCH --mem=16G
#SBATCH -o ./log/mateFix_%j.out
#SBATCH -e ./log/mateFix_%j.err
date

IBAM=$1
OBAM=$2

java -XX:+UseSerialGC -Xmx16g -Djava.io.tmpdir=./log/tmp -jar /programs/x86_64-linux/picard/2.26.10/bin/picard.jar FixMateInformation \
INPUT=$IBAM \
OUTPUT=$OBAM \
SO=coordinate \
VALIDATION_STRINGENCY=LENIENT \
CREATE_INDEX=true

date
