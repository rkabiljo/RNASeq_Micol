#!/bin/bash


# Loop through each .bam file in the star directory and submit a job
for bam_file in star_micol/*.bam; do
  echo "Submitting job for $bam_file..."
  qsub runHTseq.sh "$bam_file"
done

