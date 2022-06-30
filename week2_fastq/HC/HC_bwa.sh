#!/usr/bin/bash
#SBATCH -J HC_bwa
#SBATCH -n 1                   # Request one core
#SBATCH -N 1                    # Request one node
#SBATCH -t 2-00:00                 # Runtime in D-HH:MM format
#SBATCH -p 48core                       # Partition to run in
#SBATCH --mem=8G                        # Memory total in MB
#SBATCH -o ./log/bwa_HC%j.out           # File to which STDOUT will be written, including job ID
#SBATCH -e ./log/bwa_HC%j.err           # File to which STDERR will be written, including job ID
#SBATCH --mail-type=END,FAIL            # ALL email notification type
#SBATCH --mail-user=jmj3078@g.skku.edu     # Email to which notifications will be sent

# write your command
date

bwa mem /data/references/b37/human_g1k_v37_decoy.fasta 1C_1.fastq.gz 1C_2.fastq.gz > 1C_HC.sam
bwa mem /data/references/b37/human_g1k_v37_decoy.fasta 1F_1.fastq.gz 1F_2.fastq.gz > 1F_HC.sam

date

samtools view -b 1F_HC.sam > 1F_HC.bam
samtools view -b 1C_HC.sam > 1C_HC.bam

date

exit 0
