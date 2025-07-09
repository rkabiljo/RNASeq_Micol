#!/bin/bash -l
#$ -l h_rt=24:0:0
#$ -N getAdapt
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


#bbmerge.sh in1=fastq/01_mus2_mit_S3_R1_001.fastq.gz in2=fastq/01_mus2_mit_S3_R2_001.fastq.gz outa=adapters.fa
bbmerge.sh in1=fastq/03_mus2_mit_S6_R1_001.fastq.gz in2=fastq/03_mus2_mit_S6_R2_001.fastq.gz outa=adapters2.fa

#bbduk.sh in1=fastq/01_mus2_mit_S3_R1_001.fastq.gz in2=fastq/01_mus2_mit_S3_R2_001.fastq.gz 
#literal=auto k=23 hdist=1 stats=stats.txt out=stdout.fq

exit
bbduk.sh -Xmx4g in=fastq/01_mus2_mit_S3_R1_001.fastq.gz \
out=trimmed/01_mus2_mit_S3_R1_001.fastq.gz ref=Ref/original.adapters \
threads=2 ktrim=r k=21 mink=11 minlen=25 hdist=1 tbo tpe 

bbduk.sh -Xmx4g in=trimmed/01_mus2_mit_S3_R1_001.fastq.gz \ 
out=qual/01_mus2_mit_S3_R1_001.fastq.gz threads=2 qtrim=rl \
trimq=20 minlen=25          
