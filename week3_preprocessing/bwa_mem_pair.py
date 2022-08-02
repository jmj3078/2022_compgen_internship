import sys
import os

PLATFORM = 'Illumina'
PROJECT = 'spikeIn'
#REF='/data/references/b38/GRCh38_full_analysis_set_plus_decoy_hla.fa'
REF='/data/references/b37/human_g1k_v37_decoy.fasta'
fastqDIR='./fastq'
AlignedPath = './aligned/bwa_mem/'

cmd = 'mkdir -p '+AlignedPath
os.system(cmd)

fw = open('run.sh','w')

f = sorted(os.listdir(fastqDIR))
isPaired = False

for l in f:
	if '.gz' in l:
		TYPE = 'HC'
		if 'amp' in l:
			TYPE = 'amp'
		
		if isPaired:
			FASTQ2 = l.strip()
			SAMPLE = FASTQ2.split('_')[0]
			OPT='_'+PLATFORM+'_'+TYPE+'_'+PROJECT

			if TYPE=='HC':
				cmd = 'sbatch ./pipe_bwa_mem_HC.sh'
				cmd+=' '+PLATFORM
				cmd+=' '+TYPE
				cmd+=' '+PROJECT
				cmd+=' '+REF
				cmd+=' '+fastqDIR
				cmd+=' '+FASTQ1
				cmd+=' '+FASTQ2
				cmd+=' '+AlignedPath
				#cmd+='\"'
				#os.system(cmd)
				chkFile = AlignedPath+FASTQ1+'_'+PLATFORM+'_'+TYPE+'_'+PROJECT+'.RGadded.marked.realigned.fixed.bam'

			else:
				cmd = 'sbatch ./pipe_bwa_mem_amp.sh'
				cmd+=' '+PLATFORM
				cmd+=' '+TYPE
				cmd+=' '+PROJECT
				cmd+=' '+REF
				cmd+=' '+fastqDIR
				cmd+=' '+FASTQ1
				cmd+=' '+FASTQ2
				cmd+=' '+AlignedPath
				#cmd+='\"'
				#os.system(cmd)
				chkFile = AlignedPath+FASTQ1+'_'+PLATFORM+'_'+TYPE+'_'+PROJECT+'.RGadded.realigned.fixed.bam'

			#os.system(cmd)
			#print cmd
			fw.write(cmd+'\n')

			isPaired = False
		else:
			FASTQ1 = l.strip()
			isPaired = True

fw.flush()
fw.close()
