# RNASeq_COXFA4

Files are here on RDS
```
/mnt/gpfs/live/rd01__/ritd-ag-project-rd01is-rdspi25/RNASeq/COXFA4
```

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
```
#submit automatically if all are in the same directory - I copied them previously and indexed them
for bam_file in star_micol/*.bam; do
  echo "Submitting job for $bam_file..."
  qsub runHTseq.sh "$bam_file"
done
```
The actual command from runHTseq.sh
```
python -m HTSeq.scripts.count -f bam -s no -r pos -t exon -i gene_id "$bam_file" Ref/Homo_sapiens.GRCh38.111.gtf > counts_micol/"$base_name".htseq.cnt

```
After running HTSeq, merge all counts in one gene expression matrix
```
#in the RNASeq dir
perl merge.pl 0 1 htseq.cnt counts_micol > merged_cellular.txt
#remove ends of file names
sed -i 's/Aligned\.sortedByCoord\.out\.htseq//g' merged_cellular.txt
```


## Run Majiq with STAR output

Prepare the settings file and copy the star aligned bam files to one directory - they have to be all in one directory
```
 #cat settings_micol.ini 
[info]
bamdirs=/home/skgtrk2/Scratch/mito/RNASeq/star_micol
sjdirs=/sj
genome=mm10
strandness=None
[experiments]
case=EVELINA_S6Aligned.sortedByCoord.out,FRANCE_S5Aligned.sortedByCoord.out,BRISTOL_S3Aligned.sortedByCoord.out,TURKEY_S4Aligned.sortedByCoord.out,ROB2_S2Aligned.sortedByCoord.out,ROB1_S1Aligned.sortedByCoord.out
control=LB_S10Aligned.sortedByCoord.out,SIA7_S11Aligned.sortedByCoord.out,C5_S9Aligned.sortedByCoord.out,C1_S7Aligned.sortedByCoord.out,C2_S8Aligned.sortedByCoord.out
```
#  Run
prepare the environment
```
module purge
module load default-modules
module load beta-modules
module unload gcc-libs
module load python/3.9.6-gnu-10.2.0
source majiq/bin/activate
cd majiq
```
run
```
#build
majiq build -c settings_micol.ini /home/skgtrk2/Scratch/mito/RNASeq/Ref/Homo_sapiens.GRCh38.111.NDUFA4_NDUFA4L2.gff3 -o out_micol -j 1

#delta psi is to contrast groups
majiq deltapsi -o deltapsiOut -n case control -grp1 out_micol/EVELINA_S6Aligned.sortedByCoord.out.majiq out_micol/FRANCE_S5Aligned.sortedByCoord.out.majiq out_micol/BRISTOL_S3Aligned.sortedByCoord.out.majiq out_micol/TURKEY_S4Aligned.sortedByCoord.out.majiq out_micol/ROB2_S2Aligned.sortedByCoord.out.majiq out_micol/ROB1_S1Aligned.sortedByCoord.out.majiq -grp2 out_micol/LB_S10Aligned.sortedByCoord.out.majiq out_micol/SIA7_S11Aligned.sortedByCoord.out.majiq out_micol/C5_S9Aligned.sortedByCoord.out.majiq out_micol/C1_S7Aligned.sortedByCoord.out.majiq out_micol/C2_S8Aligned.sortedByCoord.out.majiq
```
### To view voila results in a local browser
```
ssh -v -L localhost:8080:localhost:35400 skgtrk2@kathleen.rc.ucl.ac.uk
```
Then prepare the environment in the same was as when I ran build and deltapsi
```
module purge
module load default-modules
module load beta-modules
module unload gcc-libs
module load python/3.9.6-gnu-10.2.0
source majiq/bin/activate
cd majiq
```
Run voila
```
voila view -p 35400 out_micol/splicegraph.sql deltapsiOut/case-control.deltapsi.voila
```
what for this putput:
```
2024-06-06 08:52:13,696 (PID:20499) - INFO - Command: /lustre/home/skgtrk2/majiq/bin/voila view -p 35400 out_micol/splicegraph.sql deltapsiOut/case-control.deltapsi.voila
2024-06-06 08:52:13,696 (PID:20499) - INFO - Voila v2.5.6.dev1+g8423f68
2024-06-06 08:52:22,421 (PID:20499) - INFO - ╔═══════════════════════════════════════════════════════════════╗
2024-06-06 08:52:22,421 (PID:20499) - INFO - ╠╡ ACADEMIC License applied                                     ║
2024-06-06 08:52:22,421 (PID:20499) - INFO - ║  Name: Official Majiq Academic-only License                   ║
2024-06-06 08:52:22,421 (PID:20499) - INFO - ║  File: majiq_license_academic_official.lic                    ║
2024-06-06 08:52:22,421 (PID:20499) - INFO - ║  Expiration Date: Never                                       ║
2024-06-06 08:52:22,421 (PID:20499) - INFO - ║                                                               ║
2024-06-06 08:52:22,421 (PID:20499) - INFO - ╠╡ The academic license is for non-commercial purposes by       ║
2024-06-06 08:52:22,421 (PID:20499) - INFO - ╠╡ individuals at an academic or not for profit institution.    ║
2024-06-06 08:52:22,421 (PID:20499) - INFO - ╚═══════════════════════════════════════════════════════════════╝
2024-06-06 08:52:22,421 (PID:20499) - INFO - config file: /tmp/tmpsvdvx788
2024-06-06 08:52:22,622 (PID:20499) - INFO - Creating index: /lustre/home/skgtrk2/majiq/deltapsiOut/case-control.deltapsi.voila
Indexing LSV IDs: 0 / 5
2024-06-06 08:52:27,028 (PID:20499) - INFO - Writing index: /lustre/home/skgtrk2/majiq/deltapsiOut/case-control.deltapsi.voila
Serving on http://localhost:35400

```
Then in a safari, on a laptop open http://localhost:8080, and it opens the voila results page




# Run Salmon directly from TrimGalore output

runSalmon.sh will find all paired fastqs in the same directory (where trimGalore has written the trimmed files) and run salmon on them.
The command
```
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
```
