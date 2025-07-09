#!/bin/bash -l
#$ -l h_rt=24:0:0
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
module load samtools/1.11/gnu-4.9.2
source activate htseq
export PATH=$PATH:/home/skgtrk2/Scratch/mito/RNASeq/
cd /home/skgtrk2/Scratch/mito/RNASeq/

# Change to the star directory
cd star

# Loop through each .bam file in the star directory
for bam_file in *.bam; do
  # Index the BAM file
  samtools index "$bam_file"
  echo "done indexing $bam_file"

  # Get the base name of the file (remove the directory and extension)
  base_name=$(basename "$bam_file" .bam)

  # Run HTSeq-count
  python -m HTSeq.scripts.count -f bam -s no -r pos -t exon -i gene_id "$bam_file" ../Ref/Homo_sapiens.GRCh38.111.gtf > ../counts/"$base_name".htseq.cnt
done

echo "All files processed"




#samtools index 10_fib_mit_S41Aligned.sortedByCoord.out.bam
#cd ..
#python -m HTSeq.scripts.count -f bam -s no -r pos -t exon -i gene_id star/10_fib_mit_S41Aligned.sortedByCoord.out.bam Ref/Homo_sapiens.GRCh38.111.gtf > counts/10_fib_mit_S41.htseq.cnt

