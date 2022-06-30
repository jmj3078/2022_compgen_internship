#!/usr/bin/bash
#SBATCH -n 1                               # Request one core
#SBATCH -N 1                               # Request one node (if you request more than one core with -n, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 0-04:00                         # Runtime in D-HH:MM format
#SBATCH -p 48core                          # Partition to run in
#SBATCH --mem=4G                           # Memory total in MB (for all cores)
#SBATCH -o ./bwa_%j.out                    # File to which STDOUT will be written, including job ID
#SBATCH -e ./bwa_%j.err                    # File to which STDERR will be written, including job ID
#SBATCH --mail-type=END,FAIL                   # ALL email notification type
#SBATCH --mail-user=your@email.address     # Email to which notifications will be sent

# write your command
date

bwa mem /data/references/b37/human_g1k_v37_decoy.fasta sub1000_1C_1.fastq.gz sub1000_1C_2.fastq.gz > 1C.sam

date
