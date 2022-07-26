java -XX:+UseSerialGC -Xmx8g -Djava.io.tmpdir=./log/tmp -jar /programs/x86_64-linux/picard/2.26.10/bin/picard.jar AddOrReplaceReadGroups \
INPUT=/scratch/2022_summer_internship/mjcho/FCD_project/bam/patientC_Normal.sorted.RGadded.marked.realigned.fixmated.recal.bam \
OUTPUT=/scratch/2022_summer_internship/mjcho/FCD_project/bam/Targeted_C_Normal.sorted.RGadded.marked.realigned.fixed.recal.bam \
RGLB="Targeted_C_Normal" \
RGPL="Illumina" \
RGPU="Illumina" \
RGSM="Targeted_C_Normal" \
