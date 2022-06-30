#!/usr/bin/bash
sbatch amp_GATK.sh 1C_amp/1C_amp.bam spikeIn Illumina
sbatch amp_GATK.sh 1F_amp/1F_amp.bam spikeIn Illumina
sbatch HC_GATK.sh 1C_HC/1C_HC.bam spikeIn Illumina
sbatch HC_GATK.sh 1F_HC/1F_HC.bam spikeIn Illumina