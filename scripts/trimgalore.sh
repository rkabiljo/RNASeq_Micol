#!/bin/bash -l
#$ -l h_rt=24:0:0
#$ -N bwamem
# request hyperthreading in this job
#$ -l threads=1
# request the number of virtual cores
#$ -pe mpi 160
# request 2G RAM per virtual core
#$ -l mem=2G

# set number of OpenMP threads being used per MPI process 
export OMP_NUM_THREADS=2
module purge
module load gcc-libs
module load java

echo "start trimming"
trim_galore -q 0 --paired --fastqc fastq 1.fastq.gz .fastq.gz --output_dir trimgalore
