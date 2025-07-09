#!/bin/bash -l
#$ -l h_rt=12:0:0
#$ -N bbmap
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
#module load trim_galore/0.6.10
source activate qual_trim
export PATH=$PATH:/home/skgtrk2/Scratch/mito/RNASeq/
cd /home/skgtrk2/Scratch/mito/RNASeq/


# Define the prefix as the first argument passed to the script
prefix="$1"
#EVELINA_S6
# EVELINA_S6_R2_001.fastq.gz
#EVELINA_S6_R1_001.fastq.gz
# Construct input and output file paths for R1 and R2
in_r1=/home/skgtrk2/Micol/FASTQ/${prefix}_R1_001.fastq.gz
in_r2=/home/skgtrk2/Micol/FASTQ/${prefix}_R2_001.fastq.gz

# Run trimgalore with the constructed file paths
trim_galore --paired --illumina --output_dir qual_ad_micol --quality 20 --length 25 --fastqc $in_r1 $in_r2

# Rename output files to match desired names
#mv trimmed/${prefix}_R1_001_val_1.fq.gz $out_trimmed_r1
#mv trimmed/${prefix}_R2_001_val_2.fq.gz $out_trimmed_r2


