#!/bin/bash -l
#$ -l h_rt=24:0:0
#$ -N salmon_micol
# request hyperthreading in this job
#$ -l threads=1
# request the number of virtual cores
#$ -pe mpi 160
# request 2G RAM per virtual core
#$ -l mem=1G
#$ -wd /home/skgtrk2/Scratch/mito/RNASeq
# set number of OpenMP threads being used per MPI process 
export OMP_NUM_THREADS=2
module purge
module load gcc-libs
module load java


source activate salmon
export PATH=$PATH:/home/skgtrk2/Scratch/mito/RNASeq/
cd /home/skgtrk2/Scratch/mito/RNASeq/
#salmon index -t gentrome.fa.gz -p 12 -i salmon_index -d decoys.txt --gencode

fastq_dir="/home/skgtrk2/Scratch/mito/RNASeq/qual_ad_micol"

#fastq_r1=qual_ad/${prefix}_R1_001_val_1.fq.gz
#fastq_r2=qual_ad/${prefix}_R2_001_val_2.fq.gz

find "$fastq_dir" -type f -name "*_R1_001_val_1.fq.gz" | while read -r r1_file; do
    r2_file=$(echo "$r1_file" | sed 's/_R1_001_val_1/_R2_001_val_2/')
    output_dir=$(basename "$r1_file" _R1_001_val_1.fq.gz)
    echo "Processing files:"
    echo "R1: $r1_file"
    echo "R2: $r2_file"
    salmon quant -i /home/skgtrk2/Scratch/mito/RNASeq/Ref/salmon_index \
        -l A \
        -1 $r1_file \
        -2 $r2_file \
        --seqBias \
        --gcBias \
        --useVBOpt \
        --validateMappings \
        -p 10 \
        -o "quant_micol/$output_dir"
done
