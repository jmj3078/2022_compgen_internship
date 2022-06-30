#!/usr/bin/bash
#SBATCH -n 2
#SBATCH -N 1
#SBATCH -t 0-04:00
#SBATCH -p 48core
#SBATCH --mem=2G
#SBATCH -o ./log/gatk_hardfilter_%j.out
#SBATCH -e ./log/gatk_ hardfilter_%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=jmj3078@g.skku.edu

date

gatk --java-options "-XX:+UseSerialGC -Xmx2G -Xmx2G -Djava.io.tmpdir=./log/" SelectVariants \
-V merged.vcf.gz \
-select-type SNP \
-O snps.vcf.gz

gatk --java-options "-XX:+UseSerialGC -Xmx2G -Xmx2G -Djava.io.tmpdir=./log/" SelectVariants \
-V merged.vcf.gz \
-select-type INDEL \
-O indels.vcf.gz

gatk --java-options "-XX:+UseSerialGC -Xmx2G -Xmx2G -Djava.io.tmpdir=./log/" VariantFiltration \
-V snps.vcf.gz \
-filter "QD < 2.0" --filter-name "QD2" \
-filter "QUAL < 30.0" --filter-name "QUAL30" \
-filter "SOR > 3.0" --filter-name "SOR3" \
-filter "FS > 60.0" --filter-name "FS60" \
-filter "MQ < 40.0" --filter-name "MQ40" \
-filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
-filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
-O snps_filtered.vcf.gz

gatk --java-options "-XX:+UseSerialGC -Xmx2G -Xmx2G -Djava.io.tmpdir=./log/" VariantFiltration \
-V indels.vcf.gz \
-filter "QD < 2.0" --filter-name "QD2" \
-filter "QUAL < 30.0" --filter-name "QUAL30" \
-filter "FS > 200.0" --filter-name "FS200" \
-filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" \
-O indels_filtered.vcf.gz

date