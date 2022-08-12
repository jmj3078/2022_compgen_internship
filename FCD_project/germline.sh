#!/usr/bin/bash
#SBATCH -J germline_call
#SBATCH -n 2
#SBATCH -N 1
#SBATCH -t 4-00:00
#SBATCH -p 48core
#SBATCH --mem=17G
#SBATCH -o ./log/germline_%j.out
#SBATCH -e ./log/germline_%j.err
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jmj3078@g.skku.edu
date

REF=/data/references/b37/human_g1k_v37_decoy.fasta
dbSNP=/data/references/b37/dbsnp_147_b37_common_all_20160601.vcf

INPUT=$1
BED=$2


if [ ! -d $INPUT\_germline ];then
    mkdir $INPUT\_germline
    echo "make $INPUT\_germline directory"
else
    echo "$INPUT\_germline directory already exist"
fi


gatk --java-options "-XX:+UseSerialGC -Xms16G -Xmx16G -Djava.io.tmpdir=./log/tmp/" HaplotypeCaller \
-R $REF \
-I ./bam/$INPUT\_Disease.sorted.RGadded.marked.realigned.fixed.recal.bam \
-O ./$INPUT\_germline/$INPUT\_Disease.germline.g.vcf.gz \
--dbsnp $dbSNP \
--emit-ref-confidence GVCF \
--native-pair-hmm-threads 2 \
--intervals $BED \

gatk --java-options "-XX:+UseSerialGC -Xms16G -Xmx16G -Djava.io.tmpdir=./log/tmp/" HaplotypeCaller \
-R $REF \
-I ./bam/$INPUT\_Normal.sorted.RGadded.marked.realigned.fixed.recal.bam \
-O ./$INPUT\_germline/$INPUT\_Normal.germline.g.vcf.gz \
--dbsnp $dbSNP \
--emit-ref-confidence GVCF \
--native-pair-hmm-threads 2 \
--intervals $BED

date
echo "haplptypecaller.. done"

gatk --java-options "-XX:+UseSerialGC -Xms16G -Xmx16G -Djava.io.tmpdir=./log/tmp/" GenomicsDBImport \
-V ./$INPUT\_germline/$INPUT\_Disease.germline.g.vcf.gz \
-V ./$INPUT\_germline/$INPUT\_Normal.germline.g.vcf.gz \
--genomicsdb-workspace-path ./$INPUT\_germline/merged_db \
-L $BED

gatk --java-options "-XX:+UseSerialGC -Xms16G -Xmx16G -Djava.io.tmpdir=./log/tmp/" GenotypeGVCFs -R $REF \
-V gendb://$INPUT\_germline/$INPUT\_db \
-O ./$INPUT\_germline/$INPUT\_germline.merged.vcf.gz \
--dbsnp $dbSNP

gatk --java-options "-XX:+UseSerialGC -Xms16G -Xmx16G -Djava.io.tmpdir=./log/tmp/" SelectVariants \
-V ./$INPUT\_germline/$INPUT\_germline.merged.vcf.gz \
-select-type SNP \
-O ./$INPUT\_germline/$INPUT\_germline.snps.vcf.gz

gatk --java-options "-XX:+UseSerialGC -Xms16G -Xmx16G -Djava.io.tmpdir=./log/tmp/" SelectVariants \
-V ./$INPUT\_germline/$INPUT\_germline.merged.vcf.gz \
-select-type INDEL \
-O ./$INPUT\_germline/$INPUT\_germline.indels.vcf.gz

date
echo "genotyping.. done"

gatk --java-options "-XX:+UseSerialGC -Xms16G -Xmx16G -Djava.io.tmpdir=./log/tmp/" VariantFiltration \
-V ./$INPUT\_germline/$INPUT\_germline.snps.vcf.gz \
-filter "QD < 2.0" --filter-name "QD2" \
-filter "QUAL < 30.0" --filter-name "QUAL30" \
-filter "SOR > 3.0" --filter-name "SOR3" \
-filter "FS > 60.0" --filter-name "FS60" \
-filter "MQ < 40.0" --filter-name "MQ40" \
-filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
-filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
-O ./$INPUT\_germline/$INPUT\_germline.snps.filtered.vcf.gz 

gatk --java-options "-XX:+UseSerialGC -Xms16G -Xmx16G -Djava.io.tmpdir=./log/tmp/" VariantFiltration \
-V ./$INPUT\_germline/$INPUT\_germline.indels.vcf.gz \
-filter "QD < 2.0" --filter-name "QD2" \
-filter "QUAL < 30.0" --filter-name "QUAL30" \
-filter "FS > 200.0" --filter-name "FS200" \
-filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" \
-O ./$INPUT\_germline/$INPUT\_germline.indels.filtered.vcf.gz

date
echo "hard filter ..done"


/opt/tools/annovar/convert2annovar.pl -format vcf4 ./$INPUT\_germline/$INPUT\_germline.snps.filtered.vcf.gz > ./$INPUT\_germline/$INPUT.snps.avinput
/opt/tools/annovar/convert2annovar.pl -format vcf4 ./$INPUT\_germline/$INPUT\_germline.indels.filtered.vcf.gz > ./$INPUT\_germline/$INPUT.indels.avinput

date

perl /opt/tools/annovar/table_annovar.pl \
./$INPUT\_germline/$INPUT.snps.avinput /opt/tools/annovar/humandb/ \
-buildver hg19 -out ./$INPUT\_germline/$INPUT.germline.snps.filtered -remove \
-protocol refGene,cytoBand,cosmic70,exac03,gnomad_genome,avsnp147,clinvar_20190305,HGMD.v4 \
-operation gx,r,f,f,f,f,f,f -polish \
-xref /opt/tools/annovar/example/gene_fullxref.txt \

perl /opt/tools/annovar/table_annovar.pl \
./$INPUT\_germline/$INPUT.indels.avinput /opt/tools/annovar/humandb/ \
-buildver hg19 -out ./$INPUT\_germline/$INPUT.germline.indels.filtered -remove \
-protocol refGene,cytoBand,cosmic70,exac03,gnomad_genome,avsnp147,clinvar_20190305,HGMD.v4 \
-operation gx,r,f,f,f,f,f,f -polish \
-xref /opt/tools/annovar/example/gene_fullxref.txt \

date
echo "annovar annotation ..done"