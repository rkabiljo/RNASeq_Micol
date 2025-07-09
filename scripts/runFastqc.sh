#!/bin/bash -l
#$ -l h_rt=24:0:0
#$ -N fastqcMicol1
# request hyperthreading in this job
#$ -l threads=1
# request the number of virtual cores
#$ -pe mpi 160
# request 2G RAM per virtual core
#$ -l mem=2G
#$ -wd /home/skgtrk2/Scratch/mito/RNASeq/
# set number of OpenMP threads being used per MPI process 

export OMP_NUM_THREADS=2
module purge
module load gcc-libs
module load java
module load fastqc/0.11.8 
echo "start fastqc"
cd  /home/skgtrk2/Scratch/mito/RNASeq/
#fastqc trimmed/01_mus2_mit_S3_R1_001.fastq.gz -o fastqc
fastqc /home/skgtrk2/Micol/PRJ24080/FASTQ/C2_S8_R2_001.fastq.gz -o fastqcMicol
