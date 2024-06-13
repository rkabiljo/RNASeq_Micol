library(tximport)
library(GenomicFeatures)
library(readxl)
library(readr)

#form the object needed to the actual annotation, from gtf
setwd("~/Documents/SalmonUCL")
txdb <- makeTxDbFromGFF("gencode.v45.chr_patch_hapl_scaff.annotation.gtf")
columns(txdb)
keytypes(txdb)
k <- keys(txdb, keytype = "GENEID")
tx2gene <- select(txdb, keys = k, keytype = "GENEID", columns = "TXNAME")
tx2gene<-tx2gene[,c("TXNAME","GENEID")]
head(tx2gene)
txdf <- select(txdb, keys(txdb, "GENEID"), "TXNAME", "GENEID")

#navigate to a directory above the directory where all salmon quant files are
setwd("/Users/renatakabiljo/RNASeq/quant")
fileList<-list.files(pattern = "quant.sf", recursive = TRUE)
fileList
txiTranscripts <- tximport(fileList, type="salmon", txOut =TRUE,countsFromAbundance = "scaledTPM",tx2gene=tx2gene)
dim(txiTranscripts$counts)
colnames(txiTranscripts$counts)

#get rid of the path and ending, to be left with sample names only
middlePartList <- sub("quant_micol/", "", fileList)
middlePartList <- sub("/quant.sf", "", middlePartList)
middlePartList
colnames(txiTranscripts$counts)<-middlePartList

#read phenotype table.  fix missing age at some point
pheno<-read.table("pheno.txt",sep="\t",header=TRUE)
rownames(pheno)<-pheno$sample

#prepare objects needed for DRIMSeq
cts <- txiTranscripts$counts
dim(cts)
colnames(cts)

#this is to match what is in pheno, I got rid of _S1, etc.

colnames(cts)<-c('BRISTOL','C1','C2','C5','EVELINA','FRANCE','LB','ROB1','ROB2','SIA7','TURKEY')
samps<-pheno[colnames(cts),c(1,2)]
colnames(samps)<-c("sample_id","condition")
samps$condition<-as.factor(samps$condition)
head(samps)

txdf <- txdf[match(rownames(cts),txdf$TXNAME),]
all(rownames(cts) == txdf$TXNAME)
counts <- data.frame(gene_id=txdf$GENEID,
                     feature_id=txdf$TXNAME,
                     cts)

#merge counts with transcript and gene table

#start DRIMSeq
library(DRIMSeq)
d <- dmDSdata(counts=counts, samples=samps)
d

#skip filtering if you want to keep app transcript - for plots in our case
n = nrow(samps)
n.small = min(table(samps$condition))
d <- dmFilter(d,
              min_samps_feature_expr=n.small, min_feature_expr=10,
              min_samps_feature_prop=n.small, min_feature_prop=0.1,
              min_samps_gene_expr=n, min_gene_expr=10)
d


design_full2 <- model.matrix(~ -1 + condition, data = DRIMSeq::samples(d))
d2 <- dmPrecision(d, design = design_full2)
d2 <- dmFit(d2, design = design_full2)

#play with plotting
geneID<-"ENSG00000189043.10"
plotProportions(d2, geneID, "condition",plot_type = "boxplot1")
plotProportions(d2, "ENSG00000185633.11", "condition",plot_type = "boxplot1")



