#!/bin/bash -l
#$ -l h_rt=24:0:0
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
source activate bbmap
export PATH=$PATH:/home/skgtrk2/Scratch/mito/RNASeq/
cd /home/skgtrk2/Scratch/mito/RNASeq/

bbduk.sh -Xmx4g in=fastq/01_mus2_mit_S3_R2_001.fastq.gz \
out=trimmed/01_mus2_mit_S3_R2_001.fastq.gz ref=adapters.fa \
threads=2 ktrim=r k=21 mink=11 minlen=25 hdist=1 tbo tpe 

bbduk.sh -Xmx4g in=trimmed/01_mus2_mit_S3_R2_001.fastq.gz out=qual/01_mus2_mit_S3_R2_001.fastq.gz threads=2 qtrim=rl trimq=20 minlen=25          


#not to be used, not recommended
#bbduk.sh -Xmx4g in=qual/01_mus2_mit_S3_R1_001.fastq.gz out=deduplicated/01_mus2_mit_S3_R1_001_deduplicated.fastq.gz threads=2 dedupe

exit
# Define the prefix as the first argument passed to the script
prefix="$1"

# Construct input and output file paths for R1 and R2
in_r1=fastq/${prefix}_R1_001.fastq.gz
in_r2=fastq/${prefix}_R2_001.fastq.gz

out_trimmed_r1=trimmed/${prefix}_R1_001.fastq.gz
out_trimmed_r2=trimmed/${prefix}_R2_001.fastq.gz

out_qual_r1=qual/${prefix}_R1_001.fastq.gz
out_qual_r2=qual/${prefix}_R2_001.fastq.gz

# Run bbduk.sh with the constructed file paths
bbduk.sh -Xmx4g in=$in_r1 out=$out_trimmed_r1 ref=adapters.fa threads=2 ktrim=r k=21 mink=11 minlen=25 hdist=1 tbo tpe
bbduk.sh -Xmx4g in=$in_r2 out=$out_trimmed_r2 ref=adapters.fa threads=2 ktrim=r k=21 mink=11 minlen=25 hdist=1 tbo tpe

bbduk.sh -Xmx4g in=$out_trimmed_r1 out=$out_qual_r1 threads=2 qtrim=rl trimq=20 minlen=25
bbduk.sh -Xmx4g in=$out_trimmed_r2 out=$out_qual_r2 threads=2 qtrim=rl trimq=20 minlen=25
