#!/bin/bash -l
#$ -l h_rt=12:0:0
#$ -N htseq
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
source activate htseq
export PATH=$PATH:/home/skgtrk2/Scratch/mito/RNASeq/
cd /home/skgtrk2/Scratch/mito/RNASeq

# Change to the star directory

bam_file="$1"
#Get the base name of the file (remove the directory and extension)
base_name=$(basename "$bam_file" .bam)

#Run HTSeq-count
python -m HTSeq.scripts.count -f bam -s no -r pos -t exon -i gene_id "$bam_file" Ref/Homo_sapiens.GRCh38.111.gtf > counts_micol/"$base_name".htseq.cnt

