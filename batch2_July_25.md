Prepare a conda environment

```
conda create -n rnaseq_env python=3.9 -y
conda activate rnaseq_env
conda install -c bioconda -c conda-forge fastqc trim-galore star htseq -y
conda install -c bioconda fastp -y
```


### Run fastqc on a few samples
```
fastqc ../ONT/FASTQ/LRM122_S1_R2_001.fastq.gz -o fastqc1
```
First fastqc showed two different adaptors, illuminating and poly-G

### remove poly-G with fastp
```
fastp \
   --in1 ../ONT/FASTQ/LRM122_S1_R1_001.fastq.gz \
   --in2 ../ONT/FASTQ/LRM122_S1_R2_001.fastq.gz \
   --out1 LRM122_R1.fastp.trimmed.fastq.gz \
   --out2 LRM122_R2.fastp.trimmed.fastq.gz \
   --trim_poly_g \
  --detect_adapter_for_pe \
   --length_required 20 \
   --thread 4 \
   --html fastp_report.html \
   --json fastp_report.json

```
### Check now that the quality is sufficient, maybe don't need trim_galore
```
fastqc LRM122_R1.fastp.trimmed.fastq.gz LRM122_R2.fastp.trimmed.fastq.gz -o fastqc1
```

### Create index for STAR
```
STAR --runThreadN 8 \
      --runMode genomeGenerate \
      --genomeDir genome \
     --genomeFastaFiles ../RNA_PacBio/Ref/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
     --sjdbGTFfile ../RNA_PacBio/Ref/Homo_sapiens.GRCh38.111.gtf \
    --sjdbOverhang 149


```
