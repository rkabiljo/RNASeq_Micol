# Load arrays into GenomeStudio

For that I downloaded from Illumina website
<br>1.Actual GenomeStudio app (needs regstration)
<br>2.Manifest file - when extracted it was called GDA-8v1-0_D1.bpm, which did not match the name from xls we received, but the link matched the name.  It worked.
<br>3.Cluster file
<br>4.Plink plug in to export data to Plink

<br>In GenomeStudio, I right clicked each one to update the call rate, and it went from red to 0.99+ for each sample. The eight sample failed, it was a dummy.

I exported the seven samples as PLINK, clicking to export only non zeroed SNPs.

# PLINK
I started with files: .map, .ped, and .phenotype

<br>On my own laptop:
```
./plink --file Micol --make-bed --out Micol_binary
```
log file:
```
PLINK v1.90b6.12 64-bit (28 Oct 2019)          www.cog-genomics.org/plink/1.9/
(C) 2005-2019 Shaun Purcell, Christopher Chang   GNU General Public License v3
Logging to Micol_binary.log.
Options in effect:
  --file Micol
  --make-bed
  --out Micol_binary

16384 MB RAM detected; reserving 8192 MB for main workspace.
.ped scan complete (for binary autoconversion).
Performing single-pass .bed write (1894665 variants, 7 people).
--file: Micol_binary-temporary.bed + Micol_binary-temporary.bim +
Micol_binary-temporary.fam written.
1894665 variants loaded from .bim file.
7 people (3 males, 4 females) loaded from .fam.
Using 1 thread (no multithreaded calculations invoked).
Before main variant filters, 7 founders and 0 nonfounders present.
Calculating allele frequencies... done.
Warning: 8 het. haploid genotypes present (see Micol_binary.hh ); many commands
treat these as missing.
Warning: Nonmissing nonmale Y chromosome genotype(s) present; many commands
treat these as missing.
Total genotyping rate is 0.996585.
1894665 variants and 7 people pass filters and QC.
Note: No phenotypes present.
--make-bed to Micol_binary.bed + Micol_binary.bim + Micol_binary.fam ... done.
```
#  filter SNPs
```
./plink --bfile Micol_binary --maf 0.05 --geno 0.1 --hwe 1e-6 --make-bed --out filtered_data
```
<br> logfile
```
PLINK v1.90b6.12 64-bit (28 Oct 2019)          www.cog-genomics.org/plink/1.9/
(C) 2005-2019 Shaun Purcell, Christopher Chang   GNU General Public License v3
Logging to filtered_data.log.
Options in effect:
  --bfile Micol_binary
  --geno 0.1
  --hwe 1e-6
  --maf 0.05
  --make-bed
  --out filtered_data

16384 MB RAM detected; reserving 8192 MB for main workspace.
1894665 variants loaded from .bim file.
7 people (3 males, 4 females) loaded from .fam.
Using 1 thread (no multithreaded calculations invoked).
Before main variant filters, 7 founders and 0 nonfounders present.
Calculating allele frequencies... done.
Warning: 8 het. haploid genotypes present (see filtered_data.hh ); many
commands treat these as missing.
Warning: Nonmissing nonmale Y chromosome genotype(s) present; many commands
treat these as missing.
Total genotyping rate is 0.996585.
33644 variants removed due to missing genotype data (--geno).
Warning: --hwe observation counts vary by more than 10%, due to the X
chromosome.  You may want to use a less stringent --hwe p-value threshold for X
chromosome variants.
--hwe: 0 variants removed due to Hardy-Weinberg exact test.
1238955 variants removed due to minor allele threshold(s)
(--maf/--max-maf/--mac/--max-mac).
622066 variants and 7 people pass filters and QC.
Note: No phenotypes present.
--make-bed to filtered_data.bed + filtered_data.bim + filtered_data.fam ...
done.
```
# calculate regions of homozygosity
```
./plink --bfile filtered_data --homozyg --homozyg-window-snp 50 --homozyg-window-het 1 --homozyg-window-missing 5 --homozyg-kb 1000 --homozyg-density 50 --out roh_output
```
<br>logfile
```
PLINK v1.90b6.12 64-bit (28 Oct 2019)          www.cog-genomics.org/plink/1.9/
(C) 2005-2019 Shaun Purcell, Christopher Chang   GNU General Public License v3
Logging to roh_output.log.
Options in effect:
  --bfile filtered_data
  --homozyg
  --homozyg-density 50
  --homozyg-kb 1000
  --homozyg-window-het 1
  --homozyg-window-missing 5
  --homozyg-window-snp 50
  --out roh_output

16384 MB RAM detected; reserving 8192 MB for main workspace.
622066 variants loaded from .bim file.
7 people (3 males, 4 females) loaded from .fam.
Using 1 thread (no multithreaded calculations invoked).
Before main variant filters, 7 founders and 0 nonfounders present.
Calculating allele frequencies... done.
Warning: 3 het. haploid genotypes present (see roh_output.hh ); many commands
treat these as missing.
Warning: Nonmissing nonmale Y chromosome genotype(s) present; many commands
treat these as missing.
622066 variants and 7 people pass filters and QC.
Note: No phenotypes present.
--homozyg: Scan complete, found 156 ROH.
Results saved to roh_output.hom + roh_output.hom.indiv + roh_output.hom.summary
```
# Calculate relatedness from regions of homozygosity
```
./plink --bfile filtered_data --genome --min 0.05 --out relatedness_output
```
<br>logfile
```
PLINK v1.90b6.12 64-bit (28 Oct 2019)          www.cog-genomics.org/plink/1.9/
(C) 2005-2019 Shaun Purcell, Christopher Chang   GNU General Public License v3
Logging to relatedness_output.log.
Options in effect:
  --bfile filtered_data
  --genome
  --min 0.05
  --out relatedness_output

16384 MB RAM detected; reserving 8192 MB for main workspace.
622066 variants loaded from .bim file.
7 people (3 males, 4 females) loaded from .fam.
Using up to 8 threads (change this with --threads).
Before main variant filters, 7 founders and 0 nonfounders present.
Calculating allele frequencies... done.
Warning: 3 het. haploid genotypes present (see relatedness_output.hh ); many
commands treat these as missing.
Warning: Nonmissing nonmale Y chromosome genotype(s) present; many commands
treat these as missing.
622066 variants and 7 people pass filters and QC.
Note: No phenotypes present.
Excluding 21197 variants on non-autosomes from IBD calculation.
IBD calculations complete.  
Finished writing relatedness_output.genome .
```

# Calculate Relatedness using king
```
cd /home/skgtrk2/Scratch/mito/RNASeq/array
./king -b filtered_data.bed --related
```
results are in
```
less king.kin0
```
