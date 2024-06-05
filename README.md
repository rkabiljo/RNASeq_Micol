# RNASeq_COXFA4

## Files are here on RDS

## Run FastQC on one to see if there is adapter content
```
cd /home/skgtrk2/Scratch/mito/RNASeq
qsub runFastqc.sh
```
the actual command inside the script:
```
fastqc /home/skgtrk2/Micol/PRJ24080/FASTQ/C2_S8_R2_001.fastq.gz -o fastqcMicol
```
I ran it one one sample and saw that there is Illumina adaptor, so I decided to trim it

## TrimGalore
trimming will also run FastQC, look at the log files
```
cd /home/skgtrk2/Scratch/mito/RNASeq
#submit one by one, like this - with prefix
qsub runTrimGalore.sh C5_S9
```
the command inside the script
```
trim_galore --paired --illumina --output_dir qual_ad_micol --quality 20 --length 25 --fastqc $in_r1 $in_r2
```
#output directory is qual_ad_micol and that's where trimmed fastqcs are - these are now our starting files for further analysis

## Align with Star

```
qsub alignStar.sh C5_S9
```
the command from the script:
```
fastq_r1=qual_ad_micol/${prefix}_R1_001_val_1.fq.gz
fastq_r2=qual_ad_micol/${prefix}_R2_001_val_2.fq.gz
#01_mus2_mit_S3_R1_001_val_1.fq.gz

STAR --runThreadN 6 \
     --genomeDir Ref/genome \
     --readFilesIn  $fastq_r1 $fastq_r2 \
     --sjdbGTFfile Ref/Homo_sapiens.GRCh38.111.gtf \
     --sjdbOverhang 149 \
     --outFileNamePrefix $prefix \
     --outSAMtype BAM SortedByCoordinate \
     --quantMode GeneCounts \
     --readFilesCommand zcat
```
this will produce the bam files all in the current directory. I moved them to star_micol directory. Then I indexed them like this:
```
for bam_file in *.bam; do
samtools index "$bam_file"
 done
```
## Counts with HTSeq

## Run Majiq with STAR output
```
majiq deltapsi -o deltapsiOut -n case control -grp1 out_micol/EVELINA_S6Aligned.sortedByCoord.out.majiq out_micol/FRANCE_S5Aligned.sortedByCoord.out.majiq out_micol/BRISTOL_S3Aligned.sortedByCoord.out.majiq out_micol/TURKEY_S4Aligned.sortedByCoord.out.majiq out_micol/ROB2_S2Aligned.sortedByCoord.out.majiq out_micol/ROB1_S1Aligned.sortedByCoord.out.majiq -grp2 out_micol/LB_S10Aligned.sortedByCoord.out.majiq out_micol/SIA7_S11Aligned.sortedByCoord.out.majiq out_micol/C5_S9Aligned.sortedByCoord.out.majiq out_micol/C1_S7Aligned.sortedByCoord.out.majiq out_micol/C2_S8Aligned.sortedByCoord.out.majiq

```

## Run Salmon directly from TrimGalore output
