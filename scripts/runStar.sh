#!/bin/bash -l
#$ -l h_rt=24:0:0
#$ -N starindex
# request hyperthreading in this job
#$ -l threads=1
# request the number of virtual cores
#$ -pe mpi 160
# request 2G RAM per virtual core
#$ -l mem=2G
#$ -wd /home/skgtrk2/Scratch/mito/RNASeq
# set number of OpenMP threads being used per MPI process 
export OMP_NUM_THREADS=2
module purge
module load gcc-libs
module load java
module load star/2.7.3a

export PATH=$PATH:/home/skgtrk2/Scratch/mito/RNASeq/
cd /home/skgtrk2/Scratch/mito/RNASeq/

cd Ref/genome_100


STAR --runThreadN 10 --runMode genomeGenerate \
     --genomeDir ./ --genomeFastaFiles ../Homo_sapiens.GRCh38.dna.primary_assembly.fa \
     --sjdbGTFfile ../Homo_sapiens.GRCh38.111.gtf \
     --sjdbOverhang 100
echo "done index on Homo_sapiens.GRCh38.111.gtf in genome_100"

exit

cd /home/skgtrk2/Scratch/mito/RNASeq/
STAR --runThreadN 6 \
     --genomeDir Ref/genome \
     --readFilesIn  qual/03_mus2_mit_S6_R1_001.fastq.gz   03_mus2_mit_S6_R2_001.fastq.gz \
     --sjdbGTFfile Ref/gencode.v45.chr_patch_hapl_scaff.annotation.gtf.gz \
     --sjdbOverhang 149 \
     --outFileNamePrefix 03_mus2_mit_S6 \
     --outSAMtype BAM SortedByCoordinate \
     --quantMode TranscriptomeSAM GeneCounts \
     --readFilesCommand zcat

