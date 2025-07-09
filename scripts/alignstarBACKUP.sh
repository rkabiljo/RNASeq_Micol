#!/bin/bash -l
#$ -l h_rt=24:0:0
#$ -N starAlign
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


#STAR --runThreadN 10 --runMode genomeGenerate \
#     --genomeDir ./ --genomeFastaFiles ./Homo_sapiens.GRCh38.dna.primary_assembly.fa \
#     --sjdbGTFfile ../Homo_sapiens.GRCh38.111.gtf \
#     --sjdbOverhang 149
#echo "done index"


prefix="$1"
cd /home/skgtrk2/Scratch/mito/RNASeq/

fastq_r1=qual_ad/${prefix}_R1_001_val_1.fq.gz
fastq_r2=qual_ad/${prefix}_R2_001_val_2.fq.gz
#01_mus2_mit_S3_R1_001_val_1.fq.gz

STAR --runThreadN 6 \
     --genomeDir Ref/genome_100 \
     --readFilesIn  $fastq_r1 $fastq_r2 \
     --sjdbGTFfile Ref/Homo_sapiens.GRCh38.111.gtf \
     --sjdbOverhang 100 \
     --outFileNamePrefix $prefix \
     --outSAMtype BAM SortedByCoordinate \
     --quantMode TranscriptomeSAM GeneCounts \
     --readFilesCommand zcat

