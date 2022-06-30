sbatch ./scripts/gatk_HC_gvcf.sh ./bam/1C_HC.sorted.RGadded.marked.realigend.fixed.recal.bam HC-1C ./bed/total.merged.bed
sbatch ./scripts/gatk_HC_gvcf.sh ./bam/1F_HC.sorted.RGadded.marked.realigend.fixed.recal.bam HC-1F ./bed/total.merged.bed
sbatch ./scripts/gatk_HC_gvcf.sh ./bam/1C_amp.sorted.RGadded.marked.realigend.fixed.recal.bam amp-1C ./bed/total.merged.bed
sbatch ./scripts/gatk_HC_gvcf.sh ./bam/1F_amp.sorted.RGadded.marked.realigend.fixed.recal.bam amp-1F ./bed/total.merged.bed

