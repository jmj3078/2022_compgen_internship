#!/usr/bin/bash
#SBATCH -J amp_sam2bam
#SBATCH -n 1                    # Request one core
#SBATCH -N 1                    # Request one node
#SBATCH -t 2-00:00                 # Runtime in D-HH:MM format
#SBATCH -p 48core                       # Partition to run in
#SBATCH --mem=4G                        # Memory total in MB
#SBATCH -o ./log/sam2bam_HC%j.out           # File to which STDOUT will be written, including job ID
#SBATCH -e ./log/sam2bam_HC%j.err        # File to which STDERR will be written, including job ID
#SBATCH --mail-type=END,FAIL            # ALL email notification type
#SBATCH --mail-user=jmj3078@g.skku.edu     # Email to which notifications will be sent

# write your command
date

samtools view -b 1F_amp.sam > 1F_amp.bam
samtools view -b 1C_amp.sam > 1C_amp.bam

date
