#!/usr/bin/bash
#SBATCH -J amp_2bam
#SBATCH -n 2                    # Request one core
#SBATCH -N 1                    # Request one node
#SBATCH -t 2-00:00                 # Runtime in D-HH:MM format
#SBATCH -p 48core                       # Partition to run in
#SBATCH --mem=4G                        # Memory total in MB
#SBATCH -o ./out/bwa_HC%j.out           # File to which STDOUT will be written, including job ID
#SBATCH -e ./err/bwa_HC%j.err           # File to which STDERR will be written, including job ID
#SBATCH --mail-type=END,FAIL            # ALL email notification type
#SBATCH --mail-user=jmj3078@g.skku.edu     # Email to which notifications will be sent

# write your command
date

bwa mem /data/references/b37/human_g1k_v37_decoy.fasta 1C_1.fastq.gz 1C_2.fastq.gz > 1C_amp.sam
bwa mem /data/references/b37/human_g1k_v37_decoy.fasta 1F_1.fastq.gz 1F_2.fastq.gz > 1F_amp.sam

date

samtools view -Sb 1F_amp.sam > 1F_amp.bam
samtools view -Sb 1C_amp.sam > 1C_amp.bam

date

exit 0
