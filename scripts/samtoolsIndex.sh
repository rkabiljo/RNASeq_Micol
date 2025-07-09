#!/bin/bash -l
#$ -l h_rt=10:0:0
#$ -N samtoolsindex
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
module load samtools/1.11/gnu-4.9.2

export PATH=$PATH:/home/skgtrk2/Scratch/mito/RNASeq/
cd /home/skgtrk2/Scratch/mito/RNASeq/star

# Loop through each .bam file in the star directory
for bam_file in *.bam; do
  # Index the BAM file
  samtools index "$bam_file"
  echo "done indexing $bam_file"
done
